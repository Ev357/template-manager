use color_eyre::eyre::{Result, eyre};
use reqwest::{
    blocking::Client,
    header::{ACCEPT, USER_AGENT},
};
use serde::Deserialize;

use crate::template::Template;

#[derive(Deserialize, Debug)]
pub struct DirectoryTree {
    pub tree: Vec<DirectoryItem>,
}

#[derive(Deserialize, Debug)]
pub struct DirectoryItem {
    pub path: String,
    pub r#type: String,
    pub url: String,
}

#[derive(Debug)]
pub struct File {
    pub path: String,
    pub url: String,
}

impl From<DirectoryItem> for File {
    fn from(item: DirectoryItem) -> Self {
        Self {
            path: item.path,
            url: item.url,
        }
    }
}

pub fn get_directory_tree(template: &Template) -> Result<Vec<File>> {
    let client = Client::new();

    let response = client
        .get("https://api.github.com/repos/Ev357/template-manager/git/trees/HEAD?recursive=true")
        .header(ACCEPT, "application/vnd.github+json")
        .header(USER_AGENT, env!("CARGO_PKG_NAME"))
        .send()?;

    let raw_data = response.bytes()?;

    let data = serde_json::from_slice::<DirectoryTree>(&raw_data);

    if data.is_err() {
        let text_data = String::from_utf8_lossy(&raw_data);

        return Err(eyre!("Failed to parse response:\n{text_data}"));
    }

    let files: Vec<File> = data?
        .tree
        .into_iter()
        .filter_map(|item| {
            if item.r#type != "blob" || !item.path.starts_with(&format!("templates/{template}/")) {
                return None;
            }

            let file: File = item.into();
            Some(file)
        })
        .collect();
    Ok(files)
}
