use std::path::PathBuf;

use clap::{Parser, ValueHint};

use crate::args::parsers::path::path_parser;

pub mod parsers;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
pub struct Args {
    pub template_name: String,

    #[arg(default_value = ".", value_parser = path_parser, value_hint = ValueHint::DirPath)]
    pub path: PathBuf,
}
