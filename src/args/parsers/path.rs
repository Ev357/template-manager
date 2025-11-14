use std::path::PathBuf;

use color_eyre::eyre::{Result, eyre};

pub fn path_parser(string: &str) -> Result<PathBuf> {
    let path = PathBuf::from(string);
    if !path.is_dir() {
        return Err(eyre!("Path is not a directory"));
    }

    Ok(path)
}
