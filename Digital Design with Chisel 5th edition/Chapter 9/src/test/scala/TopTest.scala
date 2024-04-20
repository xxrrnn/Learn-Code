import TimerFsm.MasterFsm
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
class TopTest extends AnyFlatSpec with ChiselScalatestTester{
  "FSM" should "pass" in {
    test(new MasterFsm()).withAnnotations(Seq(WriteVcdAnnotation)) {dut =>
      dut.io.start.poke(0.U)
      dut.clock.step()
      dut.io.start.poke(1.U)
      for(i <- 1 until 100){
        dut.clock.step()
      }
    }
  }

}