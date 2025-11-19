use clap::ValueEnum;
use template_manager_macro_derive::TemplateMacro;

#[derive(ValueEnum, TemplateMacro, Clone, Debug)]
pub enum Template {
    Rust,
    Haskell,
    SimpleHaskell,
    Python,
}
