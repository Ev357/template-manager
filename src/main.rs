use clap::Parser;
use color_eyre::eyre::Result;

use crate::args::{Args, print_completions::print_completions};

mod args;
mod template;

fn main() -> Result<()> {
    color_eyre::install()?;

    let args = Args::parse();

    if args.generate {
        print_completions();
        return Ok(());
    }

    println!("{args:#?}");

    Ok(())
}
