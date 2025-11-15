use std::path::PathBuf;

use clap::{Parser, ValueHint};

use crate::{args::parsers::path::path_parser, template::Template};

pub mod parsers;
pub mod print_completions;

#[derive(Parser, Debug)]
#[command(name = env!("CARGO_BIN_NAME"), version, about, long_about = None)]
pub struct Args {
    #[command(flatten)]
    pub template: Option<TemplateArgs>,

    #[arg(
        short,
        long,
        conflicts_with = "template",
        help = "Generates shell completions"
    )]
    pub generate: bool,
}

#[derive(clap::Args, Debug)]
#[group(id = "template")]
pub struct TemplateArgs {
    #[arg(help = "The template to use")]
    pub template_name: Template,

    #[arg(
        default_value = ".",
        value_parser = path_parser,
        value_hint = ValueHint::DirPath,
        requires = "template_name",
        help = "The path where to store the template"
    )]
    pub path: PathBuf,
}
