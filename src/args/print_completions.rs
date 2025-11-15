use std::io;

use clap::CommandFactory;
use clap_complete::generate;
use clap_complete_nushell::Nushell;

use crate::args::Args;

pub fn print_completions() {
    let mut cmd = Args::command();

    let name = cmd.get_name().to_string();
    generate(Nushell, &mut cmd, name, &mut io::stdout());
}
