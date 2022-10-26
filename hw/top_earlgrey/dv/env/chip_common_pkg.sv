// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Provides parameters, types and methods shared throughout the chip level testbench.
package chip_common_pkg;

  import dv_utils_pkg::uint;

  // Chip composition (number of hardware resources).
  parameter dv_utils_pkg::uint NUM_GPIOS = 32;
  parameter dv_utils_pkg::uint NUM_UARTS = 4;
  parameter dv_utils_pkg::uint NUM_SPI_HOSTS = 2;
  parameter dv_utils_pkg::uint NUM_I2CS = 3;
  parameter dv_utils_pkg::uint NUM_PWM_CHANNELS = pwm_reg_pkg::NOutputs;
  parameter dv_utils_pkg::uint NUM_PATTGEN_CH = pattgen_agent_pkg::NUM_PATTGEN_CHANNELS;

  // Buffer is half of SPI_DEVICE Dual Port SRAM
  parameter dv_utils_pkg::uint SPI_FRAME_BYTE_SIZE = spi_device_reg_pkg::SPI_DEVICE_BUFFER_SIZE/2;

  // SW constants - use unmapped address space with at least 32 bytes.
  parameter bit [top_pkg::TL_AW-1:0] SW_DV_START_ADDR = tl_main_pkg::ADDR_SPACE_RV_CORE_IBEX__CFG +
      rv_core_ibex_reg_pkg::RV_CORE_IBEX_DV_SIM_WINDOW_OFFSET;

  parameter bit [top_pkg::TL_AW-1:0] SW_DV_TEST_STATUS_ADDR = SW_DV_START_ADDR + 0;
  parameter bit [top_pkg::TL_AW-1:0] SW_DV_LOG_ADDR         = SW_DV_START_ADDR + 4;

  // Auto-generated parameters. TODO: rename to chip_common_pkg__params.svh.
  `include "autogen/chip_env_pkg__params.sv"

  // TODO: Eventually, move everything from chip_env_pkg to here.

  // Represents the clock source used by the chip during simulations.
  //
  // It is indicative of both, the source of the clock used for the test, as well as the frequency
  // in MHz (the literal value).
  typedef enum {
    // Use the internal clocks generated by the AST. This is the default for most tests.
    ChipClockSourceInternal = 0,

    // Use the external clock source with 48MHz frequency. This requires chip_if::ext_clk_if to be
    // connected.
    ChipClockSourceExternal48Mhz = 48,

    // Use the external clock source with 98MHz frequency (nominal). This requires
    // the chip_if::ext_clk_if to be connected.
    ChipClockSourceExternal96Mhz = 96
  } chip_clock_source_e;

  // Represents the various chip-wide control signals broadcast by the LC controller.
  //
  // The design emits these as a redundantly encoded signal of type lc_ctrl_pkg::lc_tx_t, which can
  // be compared against the {On, Off} values.
  typedef enum {
    LcCtrlSignalDftEn,
    LcCtrlSignalNvmDebugEn,
    LcCtrlSignalHwDebugEn,
    LcCtrlSignalCpuEn,
    LcCtrlSignalCreatorSeedEn,
    LcCtrlSignalOwnerSeedEn,
    LcCtrlSignalIsoRdEn,
    LcCtrlSignalIsoWrEn,
    LcCtrlSignalSeedRdEn,
    LcCtrlSignalKeyMgrEn,
    LcCtrlSignalEscEn,
    LcCtrlSignalCheckBypEn,
    LcCtrlSignalNumTotal
  } lc_ctrl_signal_e;

  // Chip IOs.
  //
  // This aggregates all chip IOs as seen at the pads.
  typedef enum {
    // Dedicated pads
    PorN,
    UsbP,
    UsbN,
    CC1,
    CC2,
    FlashTestVolt,
    FlashTestMode0,
    FlashTestMode1,
    OtpExtVolt,
    SpiHostD[0:3],  // 9
    SpiHostClk,
    SpiHostCsL,
    SpiDevD[0:3],  // 15
    SpiDevClk,
    SpiDevCsL,
    AstMisc,

    // Muxed Pads:
    IoA[0:8],  // 22
    IoB[0:12],  // 31
    IoC[0:12],  // 44

    // Note: IOR[8:9] are dedicated IOs used by sysrst_ctrl.
    IoR[0:13],  // 56

    // Total number of pads, including dedicated and muxed.
    IoNumTotal  // 70
  } chip_io_e;

  // Chip Peripherals.
  typedef enum {
    AdcCtrl,
    Aes,
    AlertHandler,
    AonTimer,
    Ast,
    Clkmgr,
    Csrng,
    Edn,
    EntropySrc,
    FlashCtrl,
    Gpio,
    Hmac,
    I2c,
    Keymgr,
    Kmac,
    LcCtrl,
    Otbn,
    OtpCtrl,
    SramCtrlMain,
    SramCtrlRet,
    Pattgen,
    Pinmux,
    Pwrmgr,
    Pwm,
    RomCrl,
    RstMgr,
    RvDm,
    RvTimer,
    SpiDevice,
    SpiHost,
    SysRstCtrl,
    Uart,
    UsbDev
  } chip_peripheral_e;

  typedef enum bit [1:0] {
    JtagTapNone = 2'b00,
    JtagTapLc = 2'b01,
    JtagTapRvDm = 2'b10,
    JtagTapDft = 2'b11
  } chip_jtag_tap_e;

  // TOP MIO/ DIO connection map
  parameter int unsigned NumMioPads = top_earlgrey_pkg::MioPadCount;
  parameter int unsigned NumDioPads = top_earlgrey_pkg::DioCount;

  parameter chip_io_e MioPads [NumMioPads] = '{
    IoA0,  // MIO2
    IoA1,  // MIO3
    IoA2,  // MIO4
    IoA3,  // MIO5
    IoA4,  // MIO6
    IoA5,  // MIO7
    IoA6,  // MIO8
    IoA7,  // MIO9
    IoA8,  // MIO10
    IoB0,  // MIO11
    IoB1,  // MIO12
    IoB2,  // MIO13
    IoB3,  // MIO14
    IoB4,  // MIO15
    IoB5,  // MIO16
    IoB6,  // MIO17
    IoB7,  // MIO18
    IoB8,  // MIO19
    IoB9,  // MIO20
    IoB10, // MIO21
    IoB11, // MIO22
    IoB12, // MIO23
    IoC0,  // MIO24
    IoC1,  // MIO25
    IoC2,  // MIO26
    IoC3,  // MIO27
    IoC4,  // MIO28
    IoC5,  // MIO29
    IoC6,  // MIO30
    IoC7,  // MIO31
    IoC8,  // MIO32
    IoC9,  // MIO33
    IoC10, // MIO34
    IoC11, // MIO35
    IoC12, // MIO36
    IoR0,  // MIO37
    IoR1,  // MIO38
    IoR2,  // MIO39
    IoR3,  // MIO40
    IoR4,  // MIO41
    IoR5,  // MIO42
    IoR6,  // MIO43
    IoR7,  // MIO44
    IoR10, // MIO45
    IoR11, // MIO46
    IoR12, // MIO47
    IoR13  // MIO48
  };
  parameter chip_io_e DioPads [NumDioPads] = '{
    UsbP,       // DIO 0
    UsbN,       // DIO 1
    SpiHostD0,  // DIO 2
    SpiHostD1,  // DIO 3
    SpiHostD2,  // DIO 4
    SpiHostD3,  // DIO 5
    SpiDevD0,   // DIO 6
    SpiDevD1,   // DIO 7
    SpiDevD2,   // DIO 8
    SpiDevD3,   // DIO 9
    IoR8,       // DIO 10 EC_RST_L
    IoR9,       // DIO 11 FLASH_WP_L
    SpiDevClk,  // DIO 12
    SpiDevCsL,  // DIO 13
    SpiHostClk, // DIO 14
    SpiHostCsL  // DIO 15
  };

  typedef struct packed {
    lc_ctrl_state_pkg::lc_state_e lc_state;
    lc_ctrl_state_pkg::dec_lc_state_e dec_lc_state;
  } lc_state_t;

  parameter lc_state_t UnlockedStates[8] = '{
    '{
      lc_state: lc_ctrl_state_pkg::LcStTestUnlocked0,
      dec_lc_state: lc_ctrl_state_pkg::DecLcStTestUnlocked0
     },
    '{
      lc_state: lc_ctrl_state_pkg::LcStTestUnlocked1,
      dec_lc_state: lc_ctrl_state_pkg::DecLcStTestUnlocked1
     },
    '{
      lc_state: lc_ctrl_state_pkg::LcStTestUnlocked2,
      dec_lc_state: lc_ctrl_state_pkg::DecLcStTestUnlocked2
     },
    '{
      lc_state: lc_ctrl_state_pkg::LcStTestUnlocked3,
      dec_lc_state: lc_ctrl_state_pkg::DecLcStTestUnlocked3
     },
    '{
      lc_state: lc_ctrl_state_pkg::LcStTestUnlocked4,
      dec_lc_state: lc_ctrl_state_pkg::DecLcStTestUnlocked4
     },
    '{
      lc_state: lc_ctrl_state_pkg::LcStTestUnlocked5,
      dec_lc_state: lc_ctrl_state_pkg::DecLcStTestUnlocked5
     },
    '{
      lc_state: lc_ctrl_state_pkg::LcStTestUnlocked6,
      dec_lc_state: lc_ctrl_state_pkg::DecLcStTestUnlocked6
     },
    '{
      lc_state: lc_ctrl_state_pkg::LcStTestUnlocked7,
      dec_lc_state: lc_ctrl_state_pkg::DecLcStTestUnlocked7
     }
  };
endpackage
