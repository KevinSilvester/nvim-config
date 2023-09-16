use git_hooks::{
    c_println,
    hash::{GitHooks, Hash, TsParsers},
    paths::Paths,
};
use tokio::runtime;

fn main() {
    let paths = Paths::new();
    let hash = Hash::new(&paths.nivm_data.join("hash"));

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

        c_println!(blue, "Hashing git-hooks...");
        hash.hash_dir(&GitHooks, &paths.git_hooks.join("src"), true)
            .await
            .unwrap();

        c_println!(blue, "Hashing ts-parsers...");
        hash.hash_dir(&TsParsers, &paths.ts_parsers.join("src"), true)
            .await
            .unwrap();

        c_println!(green, "Hashing Complete! (●'◡'●)")
    });
}
