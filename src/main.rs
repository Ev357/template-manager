use clap::Parser;
use color_eyre::eyre::Result;

use crate::args::Args;

mod args;

fn main() -> Result<()> {
    color_eyre::install()?;

    let args = Args::parse();

    println!("{:?}", args.path);

    Ok(())
}
