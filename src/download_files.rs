use std::{fs, path::PathBuf};

use color_eyre::eyre::{Result, eyre};
use reqwest::{
    blocking::Client,
    header::{ACCEPT, USER_AGENT},
};

use crate::{args::TemplateArgs, get_directory_tree::File};

pub fn download_files(files: Vec<File>, template_args: &TemplateArgs) -> Result<()> {
    let client = Client::new();

    for file in files {
        let response = client
            .get(&file.url)
            .header(ACCEPT, "application/vnd.github.raw")
            .header(USER_AGENT, env!("CARGO_PKG_NAME"))
            .send()?;

        if !response.status().is_success() {
            return Err(eyre!("Failed to download file: {}", file.url));
        }

        let prefix = format!("templates/{}", template_args.template_name);
        let absolute_path = PathBuf::from(&file.path);
        let path = absolute_path.strip_prefix(&prefix)?;

        let new_path = template_args.path.join(path);
        if let Some(parent_dir) = new_path.parent() {
            fs::create_dir_all(parent_dir)?;
        }

        let bytes = response.bytes()?;
        fs::write(&new_path, &bytes)?;
    }

    Ok(())
}
