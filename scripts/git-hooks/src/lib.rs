pub use ansi_term::Colour::RGB;

#[macro_export]
macro_rules! c_println {
    (red, $($arg:tt)*) => {{
        eprintln!("{}", $crate::RGB(235, 66, 66).paint($($arg)*))
    }};
    (blue, $($arg:tt)*) => {{
        println!("{}", $crate::RGB(2, 149, 235).paint($($arg)*))
    }};
    (green, $($arg:tt)*) => {{
        println!("{}", $crate::RGB(57, 219, 57).paint($($arg)*))
    }};
}

pub mod hash;
pub mod paths;
