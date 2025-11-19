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
        let path_suffix = absolute_path.strip_prefix(&prefix)?;

        let target_path = if let Some(path) = &template_args.path {
            path
        } else {
            &PathBuf::from(format!("{}-template", template_args.template_name))
        };

        let output_path = target_path.join(path_suffix);
        if let Some(parent_dir) = output_path.parent() {
            fs::create_dir_all(parent_dir)?;
        }

        let bytes = response.bytes()?;
        fs::write(&output_path, &bytes)?;
    }

    Ok(())
}
