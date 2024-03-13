use std::f64::consts::PI;

use rust_hdl::prelude::*;

pub fn make_sin_rom<const N: usize>() -> ROM<Signed<16>, N> {
    let depth = 2_i32.pow(N as u32);
    let iter = (0..depth).into_iter().map(|i| {
        let w = (i as f64) * 2. * PI / (depth as f64);

        let y = 2_f64.powf(15.) * w.sin() * 0.9999;

        let y = y as i64;

        y.into()
    });

    iter.into()
}
