# RISC-V Processor in Verilog

This project is a fully functional RISC-V processor implemented from scratch using Verilog HDL. It supports core instruction formats including R-type, I-type, S-type, B-type, J-type, and U-type.

## 🔧 Features
- Modular design: PC, IMEM, Decoder, Control Unit, ALU, Register File, DMEM
- Custom testbench with hand-encoded factorial program
- Simulated entirely on [EDAPlayground](https://www.edaplayground.com/) for easy debugging and waveform analysis

## 📂 Folder Structure
- `src/` – Verilog modules
- `testbench/` – Simulation testbench
- `waveform/` – Optional waveform screenshots
- `docs/` – Block diagram and presentation files

## 🧪 Verification
The processor is verified using a factorial program encoded manually in binary. Simulation confirms correct instruction decoding, data flow, and memory updates.

## 📎 License
This project is open for learning and reference. Please credit if reused.

---

Built and maintained by [Piyush](https://www.linkedin.com/in/your-profile)
