use std::io;

use clap::Command;
use clap_complete::generate;
use clap_complete_nushell::Nushell;

pub fn print_completions(cmd: &mut Command) {
    generate(Nushell, cmd, cmd.get_name().to_string(), &mut io::stdout());
}
