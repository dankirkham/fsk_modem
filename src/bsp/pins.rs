use rust_hdl::core::prelude::*;

pub const CLOCK_SPEED_48MHZ: u64 = 48_000_000;

pub fn clock() -> Signal<In, Clock> {
    let mut x = Signal::<In, _>::default();
    x.add_location(0, "F4");
    x.connect();
    x
}

pub fn user_pins() -> Signal<Out, Bits<4>> {
    let mut x = Signal::<Out, _>::default();
    for (ndx, uname) in ["E4", "D5", "E5", "F5"].iter().enumerate() {
        x.add_location(ndx, uname);
    }
    x
}
