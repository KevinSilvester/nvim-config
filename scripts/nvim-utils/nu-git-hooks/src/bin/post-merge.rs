use nu_git_hooks::hash::{Hash, NvimUtils};
use nu_lib::{c_println, command::run_command, paths::Paths};
use tokio::runtime;

fn main() {
    let paths = Paths::new();
    let hash = Hash::new(&paths.nvim_data.join("hash"));

    let threads = num_cpus::get();
    let rt = runtime::Builder::new_multi_thread()
        .enable_all()
        .worker_threads(threads)
        .thread_name("git-hooks~~post-merge")
        .thread_stack_size(3 * 1024 * 1024)
        .build()
        .unwrap();

    rt.block_on(async move {
        if !hash.hash_data_dir.is_dir() {
            c_println!(red, "Error: Hash Directory not found!");
            c_println!(red, "       Run `bootstrap` first");
        }

        c_println!(blue, "Checking ts-parsers hash...");
        let is_same = hash
            .compare_dir_hash(&NvimUtils, &paths.nvim_utils)
            .await
            .unwrap();

        if is_same {
            c_println!(green, "nvim-utils: No changes detected!");
            return;
        }

        c_println!(green, "nvim-utils: Changes detected!");

        c_println!(blue, "\nnvim-utils: Rebuiling...");
        match run_command(
            "cargo",
            &vec!["build", "--release"],
            Some(&paths.nvim_utils),
        )
        .await
        {
            Ok(_) => (),
            Err(e) => {
                dbg!(&e);
                c_println!(red, "nvim-utils: Error rebuilding: {}", e);
                return;
            }
        };
        c_println!(green, "nvim-utils: Rebuilt successfully!");

        c_println!(blue, "\nnvim-utils: Creating new hash...");
        hash.hash_dir(&NvimUtils, &paths.nvim_utils, true)
            .await
            .unwrap();
        c_println!(green, "nvim-utils: New hash created successfully!");

        c_println!(blue, "\nnvim-utils: Updating git hooks...");
        let new_bin = paths
            .nvim_utils
            .join("target")
            .join("release")
            .join("post-merge");
        self_replace::self_replace(new_bin).unwrap();
        c_println!(green, "nvim-utils: Git hooks updated successfully!");
        c_println!(green, "nvim-utils: Done! (●'◡'●)");
    });
}
