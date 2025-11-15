use std::path::PathBuf;

use clap::{Parser, ValueHint};

use crate::args::parsers::path::path_parser;

pub mod parsers;
pub mod print_completions;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
pub struct Args {
    #[command(flatten)]
    pub template: Option<TemplateArgs>,

    #[arg(short, long, conflicts_with = "template")]
    pub generate: bool,
}

#[derive(clap::Args, Debug)]
#[group(id = "template")]
pub struct TemplateArgs {
    pub template_name: String,

    #[arg(default_value = ".", value_parser = path_parser, value_hint = ValueHint::DirPath, requires = "template_name")]
    pub path: PathBuf,
}
