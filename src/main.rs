use clap::Parser;
use color_eyre::eyre::Result;

use crate::{
    args::{Args, print_completions::print_completions},
    download_files::download_files,
    get_directory_tree::get_directory_tree,
};

mod args;
mod download_files;
mod get_directory_tree;
mod template;

fn main() -> Result<()> {
    color_eyre::install()?;

    let args = Args::parse();

    if args.generate {
        print_completions();
        return Ok(());
    }

    if let Some(template) = &args.template {
        let files = get_directory_tree(&template.template_name)?;

        download_files(files, template)?;
    }

    Ok(())
}
