use rust_hdl::prelude::*;

use crate::bsp::pins;
use crate::demodulator::Demodulator;
use crate::modulator::Modulator;
use crate::buffer::Buffer;

#[derive(LogicBlock)]
pub struct Modem {
    pub clock: Signal<In, Clock>,
    pub tx: Signal<Out, Bit>,
    pub rx: Signal<In, Bit>,
    // symbol_driver: Strobe<13>,
    // lfsr: LFSRSimple,
    demodulator: Demodulator,
    modulator: Modulator,
    signal: Buffer,
    mark: DFF<Bit>,
    rx_buffer: BitSynchronizer,
}

impl Logic for Modem {
    #[hdl_gen]
    fn update(&mut self) {
        clock!(self, clock, demodulator, modulator, rx_buffer, signal);
        dff_setup!(self, clock, mark);

        self.rx_buffer.sig_in.next = self.rx.val();
        self.tx.next = self.demodulator.mark_out.val();

        // Mock UART RX
        // self.symbol_driver.enable.next = true;
        // self.lfsr.strobe.next = self.symbol_driver.strobe.val();
        // self.mark.d.next = self.lfsr.num.val().get_bit(0);

        self.modulator.mark_in.next = self.rx_buffer.sig_out.val();

        // Loopback
        self.signal.data_in.next = self.modulator.data_out.val();
        self.signal.strobe_in.next = self.modulator.strobe_out.val();
        self.demodulator.data_in.next = self.signal.data_out.val();
        self.demodulator.strobe_in.next = self.signal.strobe_out.val();
    }
}

impl Default for Modem {
    fn default() -> Self {
        Self {
            clock: pins::clock(),
            tx: pins::tx(),
            rx: pins::rx(),
            // symbol_driver: Strobe::new(pins::CLOCK_SPEED_48MHZ, 9_600.),
            mark: DFF::default(),
            // lfsr: LFSRSimple::default(),
            modulator: Modulator::default(),
            signal: Default::default(),
            demodulator: Demodulator::default(),
            rx_buffer: BitSynchronizer::default(),
        }
    }
}
