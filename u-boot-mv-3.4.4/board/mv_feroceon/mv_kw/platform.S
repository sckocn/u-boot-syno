/*******************************************************************************
Copyright (C) Marvell International Ltd. and its affiliates

********************************************************************************
Marvell GPL License Option

If you received this File from Marvell, you may opt to use, redistribute and/or 
modify this File in accordance with the terms and conditions of the General 
Public License Version 2, June 1991 (the "GPL License"), a copy of which is 
available along with the File in the license.txt file or by writing to the Free 
Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 or 
on the worldwide web at http://www.gnu.org/licenses/gpl.txt. 

THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE IMPLIED 
WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE ARE EXPRESSLY 
DISCLAIMED.  The GPL License provides additional details about this warranty 
disclaimer.

*******************************************************************************/

#define MV_ASMLANGUAGE
#include "mvOsAsm.h"
#include <config.h>
#include <version.h>
#include "mvBoardEnvSpec.h"
#include "mvCtrlEnvSpec.h"
#include "mvCpuIfRegs.h"
#include "ddr2/mvDramIfRegs.h"
#include "mvCtrlEnvAsm.h"
#if defined(MV_INC_BOARD_SPI_FLASH)
#include "spi/mvSpiSpec.h"
#endif


/*
  get_board_id - get board id from twsi eeprom
  input : r5 - board id data start offset in the eeprom
        
*/
.globl lowlevel_init

/************************************************/
/*              lowlevel_init                   *
/************************************************/

lowlevel_init:

	/* change reg base to 0xf1000000 */
	ldr     r4, =CFG_MV_REGS
        MV_DV_REG_WRITE_ASM(r4, r1, 0x20080)
	
        /* save Link Registers */
	mov	r2, lr
	
	/* Change L2 cache to exist */
        MV_REG_READ_ASM(r4, r1, 0x20128)
	orr     r4, r4, #0x18
        MV_REG_WRITE_ASM(r4, r1, 0x20128)
	/* Read operation to make sure the L2 bit is set */
        MV_REG_READ_ASM(r4, r1, 0x20128)

	/* invalidate L2 cache */
	mov	r0, #0
	mcr	p15, 1, r0, c15, c11, 0

	ldr     r4, =0x1b1b1b9b
        MV_REG_WRITE_ASM(r4, r1, 0x100e0)
	ldr     r4, =0xbbbbbbbb
        MV_REG_WRITE_ASM(r4, r1, 0x20134)
	ldr     r4, =0x00bbbbbb
        MV_REG_WRITE_ASM(r4, r1, 0x20138)

	bl      _i2cInit

        /* Initialize BUS-L to DDR configuration parameters     */
        /* Must be done prior to DDR operation                  */
#if !defined(MV_BOOTROM)
        bl      _mvCpuIfPreInit
#endif

#if defined(MV_INC_BOARD_SPI_FLASH)
	/* configure the Prescale of SPI clk Tclk = 166MHz */
	MV_REG_READ_ASM (r6, r1, MV_SPI_IF_CONFIG_REG)
	and	r6, r6, #~MV_SPI_CLK_PRESCALE_MASK
	orr	r6, r6, #0x14
	MV_REG_WRITE_ASM (r6, r1, MV_SPI_IF_CONFIG_REG)
#endif

#if !defined(MV_INC_BOARD_DDIM)
#if !defined(MV_BOOTROM)

        /* Call DRAM static initialization */
	bl	_mvDramIfStaticInit
#else
	b	done
#endif
#else /* #if !defined(MV_INC_BOARD_DDIM) */

        /* Call DRAM basic initialization to allow C runtime stack */
	bl	_mvDramIfBasicInit 

	b	done
#endif /* #if !defined(MV_INC_BOARD_DDIM) */
done:
	mov	lr, r2	
	mov pc, lr
