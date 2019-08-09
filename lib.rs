extern crate proc_macro;

use proc_macro::TokenStream;
use quote::quote;

/// 
/// 
/// Instead of writing bag!(Foo {...}) all the time, it may be nicer to write Foo! {...}.
/// The following code will create a macro with the name "Foo!" which calls "bag!(Foo {...})".
/// The important thing is to replace the first "Foo" with the convenient name you want to use
/// and the second "Foo" with the name of the struct you're wrapping.
/// ```
/// macro_rules! Foo { ( $($i:ident $op:tt $j:expr),* ) => { bag!(Foo { $($i $op $j),* }) } }
/// ```
///
//#[macro_export]
//macro_rules! build {
//    ($atype:ident { $($i:ident $op:tt $j:expr),* }) => {
//        {
//            let mut m = $atype { .. Default::default() };
//            $( build!(@op m $i $op $j); )+
//            m
//        }
//    };
//
//    (@op $m:ident $i:ident : $j:expr) => {
//        $m.$i = $j
//    };
//
//    (@op $m:ident $i:ident => $j:expr) => {
//        $m.$i = ($j).into()
//    };
//
//    (@op $m:ident $i:ident $op:tt $j:expr) => {
//        compile_error!(concat!("Invalid assignment operator: ", stringify!($op)))
//    };
//}

#[proc_macro]
pub fn build_wrapper(item: TokenStream) -> TokenStream {
    eprintln!("{:?}", &item);
    //let input = syn::parse_macro_input!(item as syn::ExprTuple);
    return item;
//    let struct_name = &input.ident;
//    let name = if input.name { &input.name } else { struct_name };
//    let result = quote! {
//        macro_rules! #name {
//            ( $($i:ident $op:tt $j:expr),* ) => { build!(#struct_name { $($i $op $j),* }) }
//        }
//    };
//    result.into()
}

