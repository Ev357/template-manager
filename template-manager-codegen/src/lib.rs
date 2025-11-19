extern crate proc_macro;

use proc_macro::TokenStream;
use quote::quote;
use syn::{self, Data};

#[proc_macro_derive(TemplateMacro)]
pub fn template_macro_derive(input: TokenStream) -> TokenStream {
    let ast = syn::parse(input).unwrap();

    impl_template_macro(&ast)
}

fn impl_template_macro(ast: &syn::DeriveInput) -> TokenStream {
    let name = &ast.ident;
    let variants = if let Data::Enum(data) = &ast.data {
        &data.variants
    } else {
        panic!("TemplateMacro can only be used on enums");
    };

    let match_arms = variants.iter().map(|variant| {
        let ident = &variant.ident;
        let kebab_case_ident = to_kebab_case(&ident.to_string());
        quote! {
            #name::#ident => #kebab_case_ident,
        }
    });

    let generate = quote! {
        impl std::fmt::Display for #name {
            fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
                let template = match self {
                    #(#match_arms)*
                };

                write!(f, "{template}")
            }
        }
    };

    generate.into()
}

fn to_kebab_case(string: &str) -> String {
    string
        .chars()
        .enumerate()
        .fold(String::new(), |mut kebab, (index, char)| {
            if index > 0 && char.is_uppercase() {
                kebab.push('-');
            }
            kebab.push(char.to_ascii_lowercase());
            kebab
        })
}
