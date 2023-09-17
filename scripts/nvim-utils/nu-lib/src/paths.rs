use std::path::PathBuf;

use cfg_if::cfg_if;

#[derive(Debug, Clone)]
pub struct Paths {
    pub nvim_config: PathBuf,
    pub nivm_data: PathBuf,
    pub nvim_utils: PathBuf,
    pub ts_parsers: PathBuf,
}

#[cfg(windows)]
const NVIM_DATA_DIR: &str = "nvim-data";

#[cfg(unix)]
const NVIM_DATA_DIR: &str = "nvim";

impl Paths {
    pub fn new() -> Self {
        cfg_if! {
            if #[cfg(target_os = "macos")] {
                let local_config_dir = dirs::home_dir().unwrap().join(".config");
                let local_data_dir = dirs::home_dir() .unwrap().join(".local").join("share");
            } else {
                let local_config_dir = dirs::config_local_dir().unwrap();
                let local_data_dir = dirs::data_local_dir().unwrap();
            }
        }

        let nvim_config = local_config_dir.join("nvim");
        let nivm_data = local_data_dir.join(NVIM_DATA_DIR);
        let nvim_utils = nvim_config.join("scripts").join("nvim-utils");
        let ts_parsers = nvim_config.join("scripts").join("ts-parsers");

        Self {
            nvim_config,
            nivm_data,
            nvim_utils,
            ts_parsers,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_paths() {
        let paths = Paths::new();
        dbg!(&paths);
        assert!(paths.nvim_config.exists(), "nvim_config not found");
        assert!(paths.nivm_data.exists(), "nvim_data not found");
        assert!(paths.nvim_utils.exists(), "nvim_utils not found");
        assert!(paths.ts_parsers.exists(), "ts_parsers not found");
    }
}
