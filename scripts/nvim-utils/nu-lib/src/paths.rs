use std::path::PathBuf;

use cfg_if::cfg_if;

#[derive(Debug, Clone)]
pub struct Paths {
    pub nvim_config: PathBuf,
    pub nvim_data: PathBuf,
    pub nvim_utils: PathBuf,
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
        let nvim_data = local_data_dir.join(NVIM_DATA_DIR);
        let nvim_utils = nvim_config.join("scripts").join("nvim-utils");

        Self {
            nvim_config,
            nvim_data,
            nvim_utils,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[allow(unused_variables)]
    fn test_paths() {
        let paths = Paths::new();
        let home_dir = dirs::home_dir().unwrap();
        let app_data_dir = dirs::data_local_dir().unwrap();

        cfg_if! {
            if #[cfg(unix)] {
                let valid_nvim_config = PathBuf::from(&format!("{}/.config/nvim", &home_dir.display()));
                let valid_nvim_data = PathBuf::from(&format!("{}/.local/share/nvim", &home_dir.display()));
                let valid_nvim_utils = PathBuf::from(&format!(
                    "{}/scripts/nvim-utils",
                    &valid_nvim_config.display()
                ));
            } else {
                let valid_nvim_config = PathBuf::from(&format!("{}/nvim", &app_data_dir.display()));
                let valid_nvim_data = PathBuf::from(&format!("{}/nvim-data", &app_data_dir.display()));
                let valid_nvim_utils = PathBuf::from(&format!(
                    "{}/scripts/nvim-utils",
                    &valid_nvim_config.display()
                ));
            }
        }

        assert_eq!(paths.nvim_config, valid_nvim_config);
        assert_eq!(paths.nvim_data, valid_nvim_data);
        assert_eq!(paths.nvim_utils, valid_nvim_utils);
    }
}
