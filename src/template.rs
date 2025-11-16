use std::fmt::{self, Display};

use clap::ValueEnum;

#[derive(ValueEnum, Clone, Debug)]
pub enum Template {
    Rust,
    Haskell,
    SimpleHaskell,
}

impl Display for Template {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Template::Rust => write!(f, "rust"),
            Template::Haskell => write!(f, "haskell"),
            Template::SimpleHaskell => write!(f, "simple-haskell"),
        }
    }
}
