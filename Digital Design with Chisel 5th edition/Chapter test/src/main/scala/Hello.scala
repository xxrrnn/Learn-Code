//object Main {
//  def main(args: Array[String]): Unit = {
//    println("Hello world!")
//  }
//}
import chisel3._
import chisel3.util._

class hello extends Module {
  val io = IO(new Bundle {
    val led = Output(UInt(1.W))
  })
  val CNT_MAX = (50000000 / 2 - 1).U
  val cntReg = RegInit(0.U(32.W))
  val blkReg = RegInit(0.U(1.W))
  cntReg := cntReg + 1.U
  when(cntReg === CNT_MAX)
  {
    cntReg := 0.U
    blkReg := ~ blkReg
  }
  io.led := blkReg
}
object Main extends App {
  // These lines generate the Verilog output
  println(
    new (chisel3.stage.ChiselStage).emitVerilog(
      new hello,
      Array(
        "--emission-options=disableMemRandomization,disableRegisterRandomization"
      )
    )
  )
}