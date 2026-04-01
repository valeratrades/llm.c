#!/home/v/nix/home/scripts/nix-run-cached

use std::process::Command;

fn cmd(program: &str, args: &[&str]) {
    let status = Command::new(program)
        .args(args)
        .current_dir("/home/v/s/tmp/c/llm.c")
        .status()
        .unwrap();
    if !status.success() {
        std::process::exit(status.code().unwrap_or(1));
    }
}

fn main() {
    cmd("bash", &["-c", "chmod u+x ./dev/download_starter_pack.sh && ./dev/download_starter_pack.sh"]);
    cmd("make", &["USE_CUDNN=1", "train_gpt2fp32cu"]);
    cmd("./train_gpt2fp32cu", &[]);
}
