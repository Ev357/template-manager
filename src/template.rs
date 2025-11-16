use std::fmt::{self, Display};

use clap::ValueEnum;

#[derive(ValueEnum, Clone, Debug)]
pub enum Template {
    Rust,
    SimpleHaskell,
}

impl Display for Template {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Template::Rust => write!(f, "rust"),
            Template::SimpleHaskell => write!(f, "simple-haskell"),
        }
    }
}
