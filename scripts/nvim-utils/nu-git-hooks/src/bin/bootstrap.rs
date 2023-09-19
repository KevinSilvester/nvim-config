use nu_git_hooks::hash::{Hash, NvimUtils};
use nu_lib::{c_println, paths::Paths};
use tokio::runtime;

fn main() {
    let paths = Paths::new();
    let hash = Hash::new(&paths.nvim_data.join("hash"));

    let threads = num_cpus::get();
    let rt = runtime::Builder::new_multi_thread()
        .enable_all()
        .worker_threads(threads)
        .thread_name("git-hooks~~bootstrap")
        .thread_stack_size(3 * 1024 * 1024)
        .build()
        .unwrap();

    rt.block_on(async move {
        hash.create_hash_data_dir().await.unwrap();

        c_println!(blue, "Hashing nvim-utils...");
        hash.hash_dir(&NvimUtils, &paths.nvim_utils, true)
            .await
            .unwrap();

        c_println!(green, "Hashing Complete! (●'◡'●)")
    });
}
