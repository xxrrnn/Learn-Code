import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
class WaveformTest extends AnyFlatSpec with ChiselScalatestTester{
  "Waveform" should "pass" in {
    test(new DeviceUnderTest).withAnnotations(Seq(WriteVcdAnnotation)) {dut =>
      dut.io.a.poke(0.U)
      dut.io.b.poke(0.U)
      dut.clock.step()
      dut.io.a.poke(1.U)
      dut.io.b.poke(0.U)
      dut.clock.step()
      dut.io.a.poke(0.U)
      dut.io.b.poke(1.U)
      dut.clock.step()
      dut.io.a.poke(1.U)
      dut.io.b.poke(1.U)
      dut.clock.step()
    }
  }
}