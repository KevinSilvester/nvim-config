use git_hooks::{
    c_println,
    command::{check_command_exists, run_command},
    hash::{Hash, TsParsers},
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
        .thread_name("git-hooks~~pre-commit")
        .thread_stack_size(3 * 1024 * 1024)
        .build()
        .unwrap();

    rt.block_on(async move {
        if !hash.hash_data_dir.is_dir() {
            c_println!(red, "Error: Hash Directory not found!");
            c_println!(red, "       Run `bootstrap` first");
        }

        // no need to check git-hooks hash

        c_println!(blue, "Checking ts-parsers hash...");
        let ts_parsers_same = if hash
            .compare_dir_hash(&TsParsers, &paths.ts_parsers.join("src"))
            .await
            .unwrap()
        {
            c_println!(green, "ts-parsers: No changes detected!");
            true
        } else {
            c_println!(green, "ts-parsers: Changes detected!");
            false
        };

        // return if hash matches
        if ts_parsers_same {
            return;
        }

        check_command_exists("pnpm").unwrap();

        if !(paths.ts_parsers.join("node_modules").is_dir()) {
            c_println!(blue, "Installing ts-parsers dependencies...");
            run_command(
                "pnpm",
                &vec!["install", "--frozen-lockfile"],
                Some(&paths.ts_parsers),
            )
            .await
            .unwrap();
        }

        c_println!(blue, "Building ts-parsers...");
        run_command("pnpm", &vec!["run", "build"], Some(&paths.ts_parsers))
            .await
            .unwrap();

        c_println!(blue, "Adding changes to git...");
        run_command("git", &vec!["add", "."], Some(&paths.ts_parsers))
            .await
            .unwrap();

        c_println!(blue, "Creating new ts-parsers hash...");
        hash.hash_dir(&TsParsers, &paths.ts_parsers.join("src"), true)
            .await
            .unwrap();
    });
}
