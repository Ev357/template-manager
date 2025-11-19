use clap::ValueEnum;
use template_manager_codegen::TemplateMacro;

#[derive(ValueEnum, TemplateMacro, Clone, Debug)]
pub enum Template {
    Rust,
    Haskell,
    SimpleHaskell,
    Python,
}
