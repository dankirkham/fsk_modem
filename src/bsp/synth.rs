use rust_hdl::core::check_error::check_all;
use rust_hdl::core::prelude::*;
use rust_hdl::fpga::toolchains::icestorm::generate_pcf;
use std::fs::{create_dir_all, remove_dir_all, File};
use std::io::Write;
use std::path::PathBuf;
use std::process::{Command, Output};
use std::str::FromStr;

fn save_stdout(output: Output, dir: &PathBuf, basename: &str) -> Result<(), std::io::Error> {
    let stdout = String::from_utf8(output.stdout).unwrap();
    let stderr = String::from_utf8(output.stderr).unwrap();
    let mut out_file = File::create(dir.clone().join(format!("{}.out", basename)))?;
    write!(out_file, "{}", stdout)?;
    let mut err_file = File::create(dir.clone().join(format!("{}.err", basename)))?;
    write!(err_file, "{}", stderr)?;
    Ok(())
}

pub fn generate_bitstream<U: Block>(mut uut: U, prefix: &str) {
    uut.connect_all();
    check_all(&uut).unwrap(); // TODO - Change from panic to return an error
    let verilog_text = generate_verilog(&uut);
    let pcf_text = generate_pcf(&uut);
    let dir = PathBuf::from_str(prefix).unwrap();
    let _ = remove_dir_all(&dir);
    let _ = create_dir_all(&dir);
    let mut v_file = File::create(dir.join("top.v")).unwrap();
    write!(v_file, "{}", verilog_text).unwrap();
    let pcf_filename = "top.pcf".to_string();
    let mut pcf_file = File::create(dir.join(pcf_filename)).unwrap();
    write!(pcf_file, "{}", pcf_text).unwrap();
    println!("Running yosys...");
    let output = Command::new("yosys")
        .current_dir(dir.clone())
        .arg(r#"-p read_verilog top.v; synth_ice40 -top top -json top.json"#)
        .output()
        .unwrap();
    save_stdout(output, &dir, "yosys_synth").unwrap();
    println!("Running nextpnr-ice40...");
    let output = Command::new("nextpnr-ice40")
        .current_dir(dir.clone())
        .args([
            "--up5k",
            "--package",
            "uwg30",
            "--freq",
            "48",
            "--pcf",
            "top.pcf",
            "--asc",
            "top.asc",
            "--json",
            "top.json",
        ])
        .output()
        .unwrap();
    save_stdout(output, &dir, "nextpnr").unwrap();
    println!("Running icepack...");
    let output = Command::new("icepack")
        .current_dir(dir.clone())
        .args(["top.asc", "top.bin"])
        .output()
        .unwrap();
    save_stdout(output, &dir, "icepack").unwrap();
}
