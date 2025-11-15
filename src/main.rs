use clap::{CommandFactory, Parser};
use color_eyre::eyre::Result;

use crate::args::{Args, print_completions::print_completions};

mod args;

fn main() -> Result<()> {
    color_eyre::install()?;

    let args = Args::parse();

    if args.generate {
        let mut cmd = Args::command();
        print_completions(&mut cmd);
        return Ok(());
    }

    println!("{args:#?}");

    Ok(())
}
