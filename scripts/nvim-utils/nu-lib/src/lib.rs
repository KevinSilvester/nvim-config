#![allow(clippy::new_without_default)]

pub use ansi_term::Colour::RGB;

#[macro_export]
macro_rules! c_println {
    (red, $($arg:tt)*) => {{
        eprintln!("{}", $crate::RGB(235, 66, 66).paint(&format!($($arg)*)))
    }};
    (blue, $($arg:tt)*) => {{
        println!("{}", $crate::RGB(2, 149, 235).paint(&format!($($arg)*)))
    }};
    (green, $($arg:tt)*) => {{
        println!("{}", $crate::RGB(57, 219, 57).paint(&format!($($arg)*)))
    }};
    (amber, $($arg:tt)*) => {{
        println!("{}", $crate::RGB(245, 181, 61).paint(&format!($($arg)*)))
    }};
}

pub mod command;
pub mod paths;
mod renderer;
