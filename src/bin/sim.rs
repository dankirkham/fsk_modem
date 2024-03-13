use rust_hdl::prelude::*;

use rtl_dds::bsp::pins::CLOCK_SPEED_48MHZ;
use rtl_dds::modem::Modem;

fn main() {
    let uut = Modem::default();

    let mut sim = simple_sim!(Modem, clock, CLOCK_SPEED_48MHZ, ep, {
        let mut x = ep.init()?;
        wait_clock_cycles!(ep, clock, x, 9 * CLOCK_SPEED_48MHZ / 1_000);
        ep.done(x)
    });

    sim.run_to_file(Box::new(uut), 10 * sim_time::ONE_MILLISECOND, "top.vcd")
        .unwrap();
    // vcd_to_svg("blinky.vcd","blinky_all.svg",&["uut.clock", "uut.led"], 0, 4 * sim_time::ONE_SEC).unwrap();
    // vcd_to_svg("blinky.vcd","blinky_pulse.svg",&["uut.clock", "uut.led"], 900 * sim_time::ONE_MILLISECOND, 1500 * sim_time::ONE_MILLISECOND).unwrap();
}
