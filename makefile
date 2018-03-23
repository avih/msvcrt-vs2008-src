####
# makefile - Makefile for Microsoft Visual C++ Run-Time Libraries
#
#   Copyright (c) Microsoft Corporation. All rights reserved.
#
# Purpose:
#   This makefile builds the Visual C++ run-time release libraries.
#   Just type NMAKE in the \MSDEV\CRT\SRC directory to build all target
#   libraries. Set environment variable LLP64=1 if you want to build for
#   IA64, LLP64=2 if you want to build for X64, or LLP64=0 if you want to
#   build for x86 hosted on a 64-bit platform.
#
###############################################################################

#
# The name of the user-generated C/C++ Run-Time Library DLL and
# imports library can be set here.  Names beginning with MSVC*
# may not be used as these are reserved for use by Microsoft.
# The names shown here are samples and are for information only.
#
RETAIL_DLL_NAME=_sample_
RETAIL_LIB_NAME=_sample_
RETAIL_DLLCPP_NAME=sample_p
RETAIL_LIBCPP_NAME=sample_p
DEBUG_DLL_NAME=_sampled_
DEBUG_LIB_NAME=_sampled_
DEBUG_DLLCPP_NAME=sampled_p
DEBUG_LIBCPP_NAME=sampled_p
RC_NAME=_sample_
RCCPP_NAME=sample_p
#
POST_BLD=1

# If your MSVC++ 9.0 installation is not in the default installation path
# of "\Program Files\Microsoft Visual Studio 9\VC" on the current drive,
# set the environment variable VCTOOLS to point to the main directory
# of your installation.  (For example, "set VCTOOLS=C:\VS.NET\VC9")

!if "$(VCTOOLS)"==""
! if "$(VCINSTALLDIR)"!=""
VCTOOLS=$(VCINSTALLDIR)
! else
VCTOOLS=\Program Files\Microsoft Visual Studio 9\VC
! endif
!endif

!if "$(VCTOOLSINC)"==""
! if "$(WINDOWSSDKDIR)"!=""
VCTOOLSINC=$(WINDOWSSDKDIR)include
! else
!error makefile: please set the environment variable VCTOOLSINC to the include directory of the windows SDK (ie. c:\Program Files\Microsoft SDKs\Windows\v6.0A\Include)
! endif
!endif

# Uncomment the following assignment if you do not want the release CRTs
# to be re-built with debug information.

#BLD_REL_NO_DBINFO=1

#
# Directories, Tools and Misc Definitions:
#
###############################################################################

#
# Determine target CPU, defaulting to same as host CPU.
#
###############################################################################

!if "$(PROCESSOR_ARCHITECTURE)"=="x86"
HOST_CPU = i386
!if "$(LLP64)"=="1"
TARGET_CPU = IA64
CPUDIR = ia64
PREFIX=.
IMP_PREFIX=
!elseif "$(LLP64)"=="2"
TARGET_CPU = AMD64
CPUDIR = amd64
PREFIX=
IMP_PREFIX=
!else
TARGET_CPU = i386
CPUDIR = intel
PREFIX=_
IMP_PREFIX=_
!endif
!elseif "$(PROCESSOR_ARCHITECTURE)"=="IA64"
HOST_CPU = IA64
! if "$(LLP64)"=="0"
TARGET_CPU = i386
CPUDIR = intel
PREFIX=_
IMP_PREFIX=_
! else
TARGET_CPU = IA64
CPUDIR = ia64
PREFIX=.
IMP_PREFIX=
! endif
!elseif "$(PROCESSOR_ARCHITECTURE)"=="AMD64"
HOST_CPU = AMD64
! if "$(LLP64)"=="0"
TARGET_CPU = i386
CPUDIR = intel
PREFIX=_
IMP_PREFIX=_
! else
TARGET_CPU = AMD64
CPUDIR = amd64
PREFIX=
IMP_PREFIX=
! endif
!else
!error makefile: unknown host CPU
!endif

# Build WINHEAP version of heap manager

WINHEAP = YES

# Include RunTimeCheck support

RTC = YES

STDCPP_SRC = stdcpp

SOURCE_OBJS = $(SOURCE_OBJS_RAW:*=*_obj)
CPPSRC_OBJS = $(CPPSRC_OBJS_RAW:*=*_obj)
SOURCE_OBJS_DLL = $(SOURCE_OBJS_RAW_DLL:*=*_obj)
CPPSRC_OBJS_DLL = $(CPPSRC_OBJS_RAW_DLL:*=*_obj)
BSKU_OBJS = $(BSKU_OBJS_RAW:*=*_obj)

# Source directories:
#
# These are the directories in which to run NMAKE to update the source
# objects and libraries they provide.  Note that there are slight
# differences between the ST/MT models and the DLL model.
#
# The dependencies directory list DEP_DIRS is the union of the MAKE_DIRS
# and MAKE_DIRS_DLL lists.
#
# In order to allow for auto source library calculation, each directory
# name must be preceded by a tilde (~) and followed by an asterisk (*).

!if "$(BLD_LIB)"==""
BLD_LIB=0
!endif
!if "$(BLD_OBJ)"==""
BLD_OBJ=0
!endif

PRE_BLD=0

MAKE_DIRS = .

MAKE_DIRS_MT = .

MAKE_DIRSP = .

MAKE_DIRS_BSKU = .

MAKE_DIRS_DLL = .

MAKE_DIRSP_DLL = .

DEP_DIRS = .

ALMAPLIB_DIR = $(CPUDIR)

TCMAPLIB_DIR = $(CPUDIR)

ALMAPDLLLIB_DIR = $(CPUDIR)

TCMAPDLLLIB_DIR = $(CPUDIR)

SDKNAMESLIB_DIR = $(CPUDIR)


# Source Objects: These are the objects and/or libraries which constitute
# the statically linked library flavors (LIBC.LIB and LIBCMT.LIB).

SOURCE_OBJS_RAW = \
 build\$(CPUDIR)\*\convert.lib \
 build\$(CPUDIR)\*\direct.lib \
 build\$(CPUDIR)\*\dos.lib \
 build\$(CPUDIR)\*\eh.lib \
 build\$(CPUDIR)\*\exec.lib \
 build\$(CPUDIR)\*\heap.lib \
!if "$(TARGET_CPU)"!="AMD64"
 build\$(CPUDIR)\*\helper.lib \
!endif
 build\$(CPUDIR)\*\lowio.lib \
 build\$(CPUDIR)\*\mbstring.lib \
 build\$(CPUDIR)\*\misc.lib \
!if "$(RTC)"=="YES"
 build\$(CPUDIR)\*\rtc.lib \
!endif
 build\$(CPUDIR)\*\startup.lib \
 build\$(CPUDIR)\*\stdio.lib \
 build\$(CPUDIR)\*\string.lib \
 $(TCMAPLIB_DIR)\tcmap.lib \
 $(ALMAPLIB_DIR)\almap.lib \
 build\$(CPUDIR)\*\time.lib \
 build\$(CPUDIR)\*\conv.lib \
 build\$(CPUDIR)\*\tran.lib

CPPSRC_OBJS_RAW = build\$(CPUDIR)\*\$(STDCPP_SRC).lib

BSKU_OBJS_RAW = build\$(CPUDIR)\*\bsku.obj

# Source Objects: These are the objects and/or libraries which constitute
# the dynamically linked library flavor (MSVCRTx0.DLL).

SOURCE_OBJS_RAW_DLL = \
 build\$(CPUDIR)\*\_setargv.obj \
 build\$(CPUDIR)\*\_wstargv.obj \
 build\$(CPUDIR)\*\chkstk.obj \
!if "$(TARGET_CPU)"=="i386"
 build\$(CPUDIR)\*\alloca16.obj \
!endif
!if "$(TARGET_CPU)"=="AMD64"
 build\$(CPUDIR)\*\chkstk2.obj \
!endif
 build\$(CPUDIR)\*\crt0dat.obj \
 build\$(CPUDIR)\*\crt0fp.obj \
 build\$(CPUDIR)\*\crt0init.obj \
 build\$(CPUDIR)\*\crt0msg.obj \
 build\$(CPUDIR)\*\crtlib.obj \
 build\$(CPUDIR)\*\mlock.obj \
 build\$(CPUDIR)\*\stdargv.obj \
 build\$(CPUDIR)\*\stdenvp.obj \
 build\$(CPUDIR)\*\thread.obj \
 build\$(CPUDIR)\*\threadex.obj \
 build\$(CPUDIR)\*\tidtable.obj \
 build\$(CPUDIR)\*\wild.obj \
 build\$(CPUDIR)\*\wstdargv.obj \
 build\$(CPUDIR)\*\wstdenvp.obj \
 build\$(CPUDIR)\*\wwild.obj \
!if "$(TARGET_CPU)"=="i386"
 build\$(CPUDIR)\*\fp8.obj \
!endif
 build\$(CPUDIR)\*\convert.lib \
 build\$(CPUDIR)\*\direct.lib \
 build\$(CPUDIR)\*\dos.lib \
 build\$(CPUDIR)\*\eh.lib \
 build\$(CPUDIR)\*\exec.lib \
 build\$(CPUDIR)\*\heap.lib \
!if "$(TARGET_CPU)"!="AMD64"
 build\$(CPUDIR)\*\helper.lib \
!endif
 build\$(CPUDIR)\*\lowio.lib \
 build\$(CPUDIR)\*\mbstring.lib \
 build\$(CPUDIR)\*\misc.lib \
!if "$(RTC)"=="YES"
 build\$(CPUDIR)\*\rtc.lib \
!endif
 build\$(CPUDIR)\*\stdio.lib \
 build\$(CPUDIR)\*\string.lib \
 build\$(CPUDIR)\*\time.lib \
 build\$(CPUDIR)\*\conv.lib \
 build\$(CPUDIR)\*\tran.lib

CPPSRC_OBJS_RAW_DLL = build\$(CPUDIR)\*\$(STDCPP_SRC).lib

UPDATE_MSG = *** Updating Component Objects ***

#
# Define names for the primary targets of this makefile.
#
###############################################################################

!if "$(IFLAG)"==""
IFLAG=-i
!else
IFLAG=
!endif

!if "$(CRT_RELDIR)"==""
CRT_RELDIR = build
!endif
RELDIR_CPU=$(CRT_RELDIR)\$(CPUDIR)
DEFFILE_DIR=$(CPUDIR)
DEFFILE2_DIR=.

#
# Tools:
#

!if "$(VERBOSE)"!="1"
LINKER=link -nologo
LINKLIB=link -lib -nologo
LINKIMPLIB=link -lib -nologo
BSCMAKE=bscmake -nologo
!else
LINKER=link
LINKLIB=link -lib
LINKIMPLIB=link -lib
BSCMAKE=bscmake
!endif

ADDITIONAL_LINK_OPT=


!if "$(TARGET_CPU)"=="IA64"
LINKER=$(LINKER) -machine:IA64
LINKLIB=$(LINKLIB) -machine:IA64
LINKIMPLIB=$(LINKIMPLIB) -machine:IA64
!endif

COMMON_DEFS=-D_MBCS -D_MB_MAP_DIRECT -D_CRTBLD -D_FN_WIDE
!if "$(WINHEAP)" == "YES"
COMMON_DEFS=$(COMMON_DEFS) -DWINHEAP
!endif
!if "$(RTC)" == "YES"
COMMON_DEFS=$(COMMON_DEFS) -D_RTC
!endif
!if "$(STDCPP_NOEH)" == "YES"
COMMON_DEFS=$(COMMON_DEFS) -D_HAS_EXCEPTIONS=0
!endif

# this version of the CRT targets Winxp and later
WINDOWS_H_DEFS=-DWIN32_LEAN_AND_MEAN -D_WIN32_WINNT=0x0501 -D_WIN32_WINDOWS=0x501 -DNTDDI_VERSION=0x05010000 -D-D-DNOSERVICE

CC_OPTS_BASE=-c -nologo -Zlp8 -W3 -WX -GFy -DWIND32

!if "$(TARGET_CPU)"=="i386"
CC_OPTS_BASE=$(CC_OPTS_BASE) -GS
AS_OPTS=-c -nologo -coff -Cx -Zm -DQUIET -D?QUIET -Di386 -D_WIN32 -DWIN32
!elseif "$(TARGET_CPU)"=="IA64"
# CC_OPTS_BASE=$(CC_OPTS_BASE) -Ap32
ZDEBUGTYPE=cv
XDEBUGTYPE=cv
!else
CC_OPTS_BASE=$(CC_OPTS_BASE)
AS_OPTS=-c -nologo -D_WIN32 -DWIN32
!endif

CC_OPTS_BASE=$(CC_OPTS_BASE) -Zc:wchar_t

CC_OPTS=$(CC_OPTS_BASE) $(WINDOWS_H_DEFS)


LINKER=$(LINKER) -NXCOMPAT -DYNAMICBASE
LINKLIB=$(LINKLIB)
LINKIMPLIB=$(LINKIMPLIB)

ST_DEFINES=$(COMMON_DEFS)
MT_DEFINES=$(ST_DEFINES) -D_MT
DLL_DEFINES=$(MT_DEFINES) -DCRTDLL
DLLCPP_DEFINES=$(MT_DEFINES) -D_DLL -DCRTDLL2


RC_OPTS=-l 409 -r
RC_DEFS=$(COMMON_DEFS) $(WINDOWS_H_DEFS)
RC_INCS=-I"$(VCTOOLSINC)"
PDBDIR_PREFIX          =  #
PDBDIR_CPU             = $(RELDIR_CPU)
PDBDIR_CPU_DLL         = $(PDBDIR_CPU)

RELEASE_CHELPER			= $(RELDIR_CPU)\chelper.lib
RELEASE_LIBCST          = $(RELDIR_CPU)\libc.lib
RELEASE_LIBCPPST        = $(RELDIR_CPU)\libcp.lib
RELEASE_LIBCMT          = $(RELDIR_CPU)\libcmt.lib
RELEASE_LIBCPPMT        = $(RELDIR_CPU)\libcpmt.lib
RELEASE_DLL             = $(RELDIR_CPU)\$(RETAIL_DLL_NAME).dll
RELEASE_DLLCPP          = $(RELDIR_CPU)\$(RETAIL_DLLCPP_NAME).dll
RELEASE_IMPLIB_DLL      = $(RELDIR_CPU)\$(RETAIL_LIB_NAME).lib
RELEASE_IMPLIB_DLLCPP   = $(RELDIR_CPU)\$(RETAIL_LIBCPP_NAME).lib
RELEASE_OLDNAMES        = $(RELDIR_CPU)\oldnames.lib
RELEASE_SAFECRT         = $(RELDIR_CPU)\safecrt.lib

RELEASE_LIBCST_PDB      = $(PDBDIR_CPU)\libc.pdb
RELEASE_LIBCPPST_PDB    = $(PDBDIR_CPU)\libcp.pdb
RELEASE_LIBCMT_PDB      = $(PDBDIR_CPU)\libcmt.pdb
RELEASE_LIBCPPMT_PDB    = $(PDBDIR_CPU)\libcpmt.pdb
RELEASE_IMPLIB_PDB      = $(PDBDIR_CPU)\$(RETAIL_LIB_NAME).pdb
RELEASE_IMPLIBCPP_PDB   = $(PDBDIR_CPU)\$(RETAIL_LIBCPP_NAME).pdb
RELEASE_SAFECRT_PDB     = $(PDBDIR_CPU)\safecrt.pdb
RELEASE_DLL_PDB         = $(PDBDIR_CPU_DLL)\$(RETAIL_DLL_NAME)$(_PDB_VER_NAME_).pdb
RELEASE_DLLCPP_PDB      = $(PDBDIR_CPU_DLL)\$(RETAIL_DLLCPP_NAME)$(_PDB_VER_NAME_).pdb

RELEASE_DLL_NOVER_PDB         = $(PDBDIR_CPU_DLL)\$(RETAIL_DLL_NAME).pdb
RELEASE_DLLCPP_NOVER_PDB      = $(PDBDIR_CPU_DLL)\$(RETAIL_DLLCPP_NAME).pdb

RELEASE_LIBCST_DBG      = $(RELDIR_CPU)\libcd.lib
RELEASE_LIBCPPST_DBG    = $(RELDIR_CPU)\libcpd.lib
RELEASE_LIBCMT_DBG      = $(RELDIR_CPU)\libcmtd.lib
RELEASE_LIBCPPMT_DBG    = $(RELDIR_CPU)\libcpmtd.lib
RELEASE_DLL_DBG         = $(RELDIR_CPU)\$(DEBUG_DLL_NAME).dll
RELEASE_DLLCPP_DBG      = $(RELDIR_CPU)\$(DEBUG_DLLCPP_NAME).dll
RELEASE_IMPLIB_DLL_DBG  	= $(RELDIR_CPU)\$(DEBUG_LIB_NAME).lib
RELEASE_IMPLIB_DLLCPP_DBG 	= $(RELDIR_CPU)\$(DEBUG_LIBCPP_NAME).lib

RELEASE_LIBCST_DBG_PDB  = $(PDBDIR_CPU)\libcd.pdb
RELEASE_LIBCPPST_DBG_PDB 	= $(PDBDIR_CPU)\libcpd.pdb
RELEASE_LIBCMT_DBG_PDB  = $(PDBDIR_CPU)\libcmtd.pdb
RELEASE_LIBCPPMT_DBG_PDB 	= $(PDBDIR_CPU)\libcpmtd.pdb
RELEASE_IMPLIB_DBG_PDB     	= $(PDBDIR_CPU)\$(DEBUG_LIB_NAME).pdb
RELEASE_IMPLIBCPP_DBG_PDB  	= $(PDBDIR_CPU)\$(DEBUG_LIBCPP_NAME).pdb
RELEASE_DLL_DBG_PDB     = $(PDBDIR_CPU_DLL)\$(DEBUG_DLL_NAME)$(_PDB_VER_NAME_).pdb
RELEASE_DLLCPP_DBG_PDB  = $(PDBDIR_CPU_DLL)\$(DEBUG_DLLCPP_NAME)$(_PDB_VER_NAME_).pdb

RELEASE_DLL_DBG_NOVER_PDB     = $(PDBDIR_CPU_DLL)\$(DEBUG_DLL_NAME).pdb
RELEASE_DLLCPP_DBG_NOVER_PDB  = $(PDBDIR_CPU_DLL)\$(DEBUG_DLLCPP_NAME).pdb


FD_REL_ST=-Fd$(PDBDIR_PREFIX)$(RELEASE_LIBCST_PDB)
FD_REL_STP=-Fd$(PDBDIR_PREFIX)$(RELEASE_LIBCPPST_PDB)
FD_REL_MT=-Fd$(PDBDIR_PREFIX)$(RELEASE_LIBCMT_PDB)
FD_REL_MTP=-Fd$(PDBDIR_PREFIX)$(RELEASE_LIBCPPMT_PDB)
FD_REL_DLL=-Fd$(PDBDIR_PREFIX)$(RELEASE_IMPLIB_PDB)
FD_REL_DLLP=-Fd$(PDBDIR_PREFIX)$(RELEASE_IMPLIBCPP_PDB)


FD_REL_ST_DBG=-Fd$(PDBDIR_PREFIX)$(RELEASE_LIBCST_DBG_PDB)
FD_REL_STP_DBG=-Fd$(PDBDIR_PREFIX)$(RELEASE_LIBCPPST_DBG_PDB)
FD_REL_MT_DBG=-Fd$(PDBDIR_PREFIX)$(RELEASE_LIBCMT_DBG_PDB)
FD_REL_MTP_DBG=-Fd$(PDBDIR_PREFIX)$(RELEASE_LIBCPPMT_DBG_PDB)
FD_REL_DLL_DBG=-Fd$(PDBDIR_PREFIX)$(RELEASE_IMPLIB_DBG_PDB)
FD_REL_DLLP_DBG=-Fd$(PDBDIR_PREFIX)$(RELEASE_IMPLIBCPP_DBG_PDB)


#
# Locate the scratch location for object files of various flavors.
#
###############################################################################

OBJROOT = build
OBJDIR_PREFIX =  #
OBJCPUDIR = $(OBJROOT)\$(CPUDIR)

CPP_OBJ_DIR  = cpp_obj
MT_LIB_DIR  = mt_lib

OBJDIR_ST  = $(OBJCPUDIR)\st_obj
OBJDIR_MT  = $(OBJCPUDIR)\mt_obj
OBJDIR_DLL = $(OBJCPUDIR)\dll_obj

OBJDIR_OLDNAMES = $(OBJDIR_ST)\oldnames
OBJDIR_ALMAP = $(OBJDIR_ST)\almap
OBJDIR_TCMAP = $(OBJDIR_ST)\tcmap
OBJDIR_ALMAPDLL = $(OBJDIR_DLL)\almap
OBJDIR_TCMAPDLL = $(OBJDIR_DLL)\tcmap
OBJDIR_SDKNAMES = $(OBJDIR_DLL)\sdknames

OBJDIR_DLL_RAW = $(OBJCPUDIR)\*_obj


OBJDIR_ST_DBG  = $(OBJCPUDIR)\xst_obj
OBJDIR_MT_DBG  = $(OBJCPUDIR)\xmt_obj
OBJDIR_DLL_DBG = $(OBJCPUDIR)\xdll_obj



all : release debug

release : mt dll \

debug : xmt xdll


####
#
# Directory Targets
#
####

$(OBJDIR_ST) $(OBJDIR_MT) $(OBJDIR_DLL) \
$(OBJDIR_ST)\$(CPP_OBJ_DIR) $(OBJDIR_MT)\$(CPP_OBJ_DIR) $(OBJDIR_DLL)\$(CPP_OBJ_DIR) \
$(OBJDIR_OLDNAMES) $(OBJDIR_SDKNAMES) $(OBJDIR_ALMAP) $(OBJDIR_TCMAP) $(OBJDIR_ALMAPDLL) $(OBJDIR_TCMAPDLL) \
$(OBJDIR_ST_DBG) $(OBJDIR_MT_DBG) $(OBJDIR_DLL_DBG) \
$(OBJDIR_ST_DBG)\$(CPP_OBJ_DIR) $(OBJDIR_MT_DBG)\$(CPP_OBJ_DIR) \
$(OBJDIR_DLL_DBG)\$(CPP_OBJ_DIR) \
!if "$(PDBDIR_CPU_DLL)"!="$(RELDIR_CPU)"
$(PDBDIR_CPU_DLL) \
!endif
$(CRT_RELDIR) $(RELDIR_CPU) :
    if not exist $@\* mkdir $@

####
#
# Define the path to return to the main directory where nmake is revoked
#
####

CD_ROOT=.


####
#
# Pseudo-target user interface:
#
####

st_env :
!if "$(BLD_LIB)"!="1"
    !@-echo. \
    & echo # *** These are the compiler switches for the ST model (LIBC.LIB): \
    & echo # \
    & echo # CL = $(CC_OPTS_BASE) \ \
    & echo # $(WINDOWS_H_DEFS) $(FD_REL_ST) \ \
    & echo # $(ST_DEFINES) \
    & echo # \
    & echo # ML = $(AS_OPTS) \ \
    & echo # $(ST_DEFINES) \
    & echo.
!endif

stp_env :
!if "$(PRE_BLD)"!="1" && "$(BLD_LIB)"!="1"
    !@-echo. \
    & echo # *** These are the compiler switches for the ST model (LIBCP.LIB): \
    & echo # \
    & echo # CL = $(CC_OPTS_BASE) \ \
    & echo # $(WINDOWS_H_DEFS) $(FD_REL_STP) \ \
    & echo # $(ST_DEFINES) \
    & echo # \
    & echo # ML = $(AS_OPTS) \ \
    & echo # $(ST_DEFINES) \
    & echo.
!endif

st : $(OBJROOT) $(OBJCPUDIR) $(OBJDIR_ST) $(RELDIR_CPU) \
	$(OBJDIR_ST)\$(CPP_OBJ_DIR) st_env st_ stp_env st_p
!if "$(BLD_BROWSE)"=="1" && "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1"
    $(BSCMAKE) -o $(RELEASE_LIBCST:.lib=.bsc) $(OBJDIR_ST)\*.sbr
!endif

!if "$(BLD_LIB)"!="1"
st_ :: $(MAKE_DIRS)
    !@-cd $** \
    & set CL=$(CC_OPTS) $(ST_DEFINES) $(FD_REL_ST) \
    & set ML=$(AS_OPTS) $(ST_DEFINES) \
    & $(MAKE) -nologo $(IFLAG) -f makefile.sub DIR=$** CPUDIR=$(CPUDIR) \
        WINHEAP=$(WINHEAP) RTC=$(RTC) \
	BLD_REL_NO_DBINFO=$(BLD_REL_NO_DBINFO) \
        BLD_MODEL=st OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_ST) \
        CPP_OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_ST)\$(CPP_OBJ_DIR) \
        TARGET_CPU=$(TARGET_CPU) HOST_CPU=$(HOST_CPU) \
        VCTOOLSINC="$(VCTOOLSINC)" \
        PRE_BLD=$(PRE_BLD) POST_BLD=$(POST_BLD) \
    & cd $(CD_ROOT)

!if "$(PRE_BLD)"!="1"
st_p :: $(MAKE_DIRSP)
    !@-cd $** \
    & set CL=$(CC_OPTS) $(ST_DEFINES) $(FD_REL_STP) \
    & set ML=$(AS_OPTS) $(ST_DEFINES) \
    & $(MAKE) -nologo $(IFLAG) -f makefile.sub DIR=$** CPUDIR=$(CPUDIR) \
        WINHEAP=$(WINHEAP) RTC=$(RTC) \
	BLD_REL_NO_DBINFO=$(BLD_REL_NO_DBINFO) \
        BLD_MODEL=st OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_ST) \
        CPP_OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_ST)\$(CPP_OBJ_DIR) \
        TARGET_CPU=$(TARGET_CPU) HOST_CPU=$(HOST_CPU) \
        VCTOOLSINC="$(VCTOOLSINC)" \
        PRE_BLD=$(PRE_BLD) POST_BLD=$(POST_BLD) _stdcpp_ \
    & cd $(CD_ROOT)

!endif
!endif # BLD_LIB != 1

!if "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1"
st_ :: $(RELEASE_LIBCST)

st_p :: $(RELEASE_LIBCPPST)

!else
st_ ::

st_p ::

!endif

mt_env :
!if "$(BLD_LIB)"!="1"
    !@-echo. \
    & echo # *** These are the compiler switches for the MT model (LIBCMT.LIB): \
    & echo # \
    & echo # CL = $(CC_OPTS_BASE) \ \
    & echo # $(WINDOWS_H_DEFS) $(FD_REL_MT) \ \
    & echo # $(MT_DEFINES) \
    & echo # \
    & echo # ML = $(AS_OPTS) \ \
    & echo # $(MT_DEFINES) \
    & echo.
!endif

mtp_env :
!if "$(PRE_BLD)"!="1" && "$(BLD_LIB)"!="1"
    !@-echo. \
    & echo # *** These are the compiler switches for the MT model (LIBCPMT.LIB): \
    & echo # \
    & echo # CL = $(CC_OPTS_BASE) \ \
    & echo # $(WINDOWS_H_DEFS) $(FD_REL_MTP) \ \
    & echo # $(MT_DEFINES) \
    & echo # \
    & echo # ML = $(AS_OPTS) \ \
    & echo # $(MT_DEFINES) \
    & echo.
!endif

mt : $(OBJROOT) $(OBJCPUDIR) $(OBJDIR_MT) $(RELDIR_CPU) \
	$(OBJDIR_MT)\$(CPP_OBJ_DIR)\
	mt_env mt_ mtp_env mt_p
!if "$(BLD_BROWSE)"=="1" && "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1"
    $(BSCMAKE) -o $(RELEASE_LIBCMT:.lib=.bsc) $(OBJDIR_MT)\*.sbr
!endif

!if "$(BLD_LIB)"!="1"
mt_ :: $(MAKE_DIRS_MT)
    !@-cd $** \
    & set CL=$(CC_OPTS) $(MT_DEFINES) $(FD_REL_MT) \
    & set ML=$(AS_OPTS) $(MT_DEFINES) \
    & $(MAKE) -nologo $(IFLAG) -f makefile.sub DIR=$** CPUDIR=$(CPUDIR) \
        WINHEAP=$(WINHEAP) RTC=$(RTC) \
	BLD_REL_NO_DBINFO=$(BLD_REL_NO_DBINFO) \
        BLD_MODEL=mt OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_MT) \
        CPP_OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_MT)\$(CPP_OBJ_DIR) \
        TARGET_CPU=$(TARGET_CPU) HOST_CPU=$(HOST_CPU) \
        MT_LIB_DIR=$(MT_LIB_DIR) \
        VCTOOLSINC="$(VCTOOLSINC)" \
        PRE_BLD=$(PRE_BLD) POST_BLD=$(POST_BLD) \
    & cd $(CD_ROOT)

!if "$(PRE_BLD)"!="1"
mt_p :: $(MAKE_DIRSP)
    !@-cd $** \
    & set CL=$(CC_OPTS) $(MT_DEFINES) $(FD_REL_MTP) \
    & set ML=$(AS_OPTS) $(MT_DEFINES) \
    & $(MAKE) -nologo $(IFLAG) -f makefile.sub DIR=$** CPUDIR=$(CPUDIR) \
        WINHEAP=$(WINHEAP) RTC=$(RTC) \
	BLD_REL_NO_DBINFO=$(BLD_REL_NO_DBINFO) \
        BLD_MODEL=mt OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_MT) \
        CPP_OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_MT)\$(CPP_OBJ_DIR) \
        TARGET_CPU=$(TARGET_CPU) HOST_CPU=$(HOST_CPU) \
        MT_LIB_DIR=$(MT_LIB_DIR) \
        VCTOOLSINC="$(VCTOOLSINC)" \
        PRE_BLD=$(PRE_BLD) POST_BLD=$(POST_BLD) _stdcpp_ \
    & cd $(CD_ROOT)

!endif
!endif # BLD_LIB != 1

!if "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1"
mt_ :: $(RELEASE_LIBCMT)

mt_p :: $(RELEASE_LIBCPPMT)

!else
mt_ ::

mt_p ::
!endif

dll_env :
!if "$(BLD_LIB)"!="1"
    !@-echo. \
    & echo # *** These are the compiler switches for the DLL model (MSVCRT.LIB): \
    & echo # \
    & echo # CL = $(CC_OPTS_BASE) \ \
    & echo # $(WINDOWS_H_DEFS) $(FD_REL_DLL) \ \
    & echo # $(DLL_DEFINES) \
    & echo # \
    & echo # ML = $(AS_OPTS) \ \
    & echo # $(DLL_DEFINES) \
    & echo.
!endif

dllp_env :
!if "$(PRE_BLD)"!="1" && "$(BLD_LIB)"!="1"
    !@-echo. \
    & echo # *** These are the compiler switches for the DLL model (MSVCPRT.LIB): \
    & echo # \
    & echo # CL = $(CC_OPTS_BASE) \ \
    & echo # $(WINDOWS_H_DEFS) $(FD_REL_DLLP) \ \
    & echo # $(DLLCPP_DEFINES) \
    & echo # \
    & echo # ML = $(AS_OPTS) \ \
    & echo # $(DLLCPP_DEFINES) \
    & echo.
!endif

dll : $(OBJROOT) $(OBJCPUDIR) $(OBJDIR_DLL) \
   	$(OBJDIR_DLL)\$(CPP_OBJ_DIR) \
   	$(RELDIR_CPU) $(PDBDIR_CPU_DLL) others dll_env dll_	\
	dllp_env dll_p
!if "$(BLD_BROWSE)"=="1" && "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1"
    $(BSCMAKE) -o $(RELEASE_IMPLIB_DLL:.lib=.bsc) $(OBJDIR_DLL)\*.sbr
!endif

!if "$(BLD_LIB)"!="1"
dll_ :: $(MAKE_DIRS_DLL)
    !@-cd $** \
    & set CL=$(CC_OPTS) $(DLL_DEFINES) $(FD_REL_DLL) \
    & set ML=$(AS_OPTS) $(DLL_DEFINES) \
    & $(MAKE) -nologo $(IFLAG) -f makefile.sub DIR=$** CPUDIR=$(CPUDIR) \
        WINHEAP=$(WINHEAP) RTC=$(RTC) \
	BLD_REL_NO_DBINFO=$(BLD_REL_NO_DBINFO) \
        BLD_MODEL=dll BLD_DLL=1 OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_DLL) \
        CPP_OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_DLL)\$(CPP_OBJ_DIR) \
		TARGET_CPU=$(TARGET_CPU) HOST_CPU=$(HOST_CPU) \
        VCTOOLSINC="$(VCTOOLSINC)" \
        PRE_BLD=$(PRE_BLD) POST_BLD=$(POST_BLD) \
    & cd $(CD_ROOT)

!if "$(PRE_BLD)"!="1"
dll_p :: $(MAKE_DIRSP_DLL)
    !@-cd $** \
    & set CL=$(CC_OPTS) $(DLLCPP_DEFINES) $(FD_REL_DLLP) \
    & set ML=$(AS_OPTS) $(DLLCPP_DEFINES) \
    & $(MAKE) -nologo $(IFLAG) -f makefile.sub DIR=$** CPUDIR=$(CPUDIR) \
        WINHEAP=$(WINHEAP) RTC=$(RTC) \
	BLD_REL_NO_DBINFO=$(BLD_REL_NO_DBINFO) \
        BLD_MODEL=dll BLD_DLL=1 OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_DLL) \
        CPP_OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_DLL)\$(CPP_OBJ_DIR) \
        TARGET_CPU=$(TARGET_CPU) HOST_CPU=$(HOST_CPU) \
        VCTOOLSINC="$(VCTOOLSINC)" \
        PRE_BLD=$(PRE_BLD) POST_BLD=$(POST_BLD) _stdcpp_ \
    & cd $(CD_ROOT)

!endif

!endif # BLD_LIB != 1

!if "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1"
dll_ :: $(RELEASE_DLL)

dll_p :: $(RELEASE_DLLCPP)

!else
dll_ ::

dll_p ::

!endif


xst_env :
!if "$(BLD_LIB)"!="1"
    !@-echo. \
    & echo # *** These are the compiler switches for the XST model (LIBCD.LIB): \
    & echo # \
    & echo # CL = $(CC_OPTS_BASE) \ \
    & echo # $(WINDOWS_H_DEFS) $(FD_REL_ST_DBG) \ \
    & echo # $(ST_DEFINES) \
    & echo # \
    & echo # ML = $(AS_OPTS) \ \
    & echo # $(ST_DEFINES) \
    & echo.
!endif

xstp_env :
!if "$(PRE_BLD)"!="1" && "$(BLD_LIB)"!="1"
    !@-echo. \
    & echo # *** These are the compiler switches for the XST model (LIBCPD.LIB): \
    & echo # \
    & echo # CL = $(CC_OPTS_BASE) \ \
    & echo # $(WINDOWS_H_DEFS) $(FD_REL_STP_DBG) \ \
    & echo # $(ST_DEFINES) \
    & echo # \
    & echo # ML = $(AS_OPTS) \ \
    & echo # $(ST_DEFINES) \
    & echo.
!endif

xst : $(OBJROOT) $(OBJCPUDIR) $(OBJDIR_ST_DBG) $(RELDIR_CPU) \
	$(OBJDIR_ST_DBG)\$(CPP_OBJ_DIR) xst_env xst_ xstp_env xst_p
!if "$(BLD_BROWSE)"=="1" && "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1"
    $(BSCMAKE) -o $(RELEASE_LIBCST_DBG:.lib=.bsc) $(OBJDIR_ST_DBG)\*.sbr
!endif

!if "$(BLD_LIB)"!="1"
xst_ :: $(MAKE_DIRS)
    !@-cd $** \
    & set CL=$(CC_OPTS) $(ST_DEFINES) $(FD_REL_ST_DBG) \
    & set ML=$(AS_OPTS) $(ST_DEFINES) \
    & $(MAKE) -nologo $(IFLAG) -f makefile.sub DIR=$** CPUDIR=$(CPUDIR) \
        WINHEAP=$(WINHEAP) RTC=$(RTC) \
	BLD_REL_NO_DBINFO=$(BLD_REL_NO_DBINFO) \
        BLD_MODEL=xst BLD_DBG=1 OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_ST_DBG) \
        CPP_OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_ST_DBG)\$(CPP_OBJ_DIR) \
        TARGET_CPU=$(TARGET_CPU) HOST_CPU=$(HOST_CPU) \
        VCTOOLSINC="$(VCTOOLSINC)" \
        PRE_BLD=$(PRE_BLD) POST_BLD=$(POST_BLD) \
    & cd $(CD_ROOT)

!if "$(PRE_BLD)"!="1"
xst_p :: $(MAKE_DIRSP)
    !@-cd $** \
    & set CL=$(CC_OPTS) $(ST_DEFINES) $(FD_REL_STP_DBG) \
    & set ML=$(AS_OPTS) $(ST_DEFINES) \
    & $(MAKE) -nologo $(IFLAG) -f makefile.sub DIR=$** CPUDIR=$(CPUDIR) \
        WINHEAP=$(WINHEAP) RTC=$(RTC) \
	BLD_REL_NO_DBINFO=$(BLD_REL_NO_DBINFO) \
        BLD_MODEL=xst BLD_DBG=1 OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_ST_DBG) \
        CPP_OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_ST_DBG)\$(CPP_OBJ_DIR) \
        TARGET_CPU=$(TARGET_CPU) HOST_CPU=$(HOST_CPU) \
        VCTOOLSINC="$(VCTOOLSINC)" \
        PRE_BLD=$(PRE_BLD) POST_BLD=$(POST_BLD) _stdcpp_ \
    & cd $(CD_ROOT)

!endif
!endif # BLD_LIB != 1

!if "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1"
xst_ :: $(RELEASE_LIBCST_DBG)

xst_p :: $(RELEASE_LIBCPPST_DBG)
!else
xst_ ::

xst_p ::
!endif

xmt_env :
!if "$(BLD_LIB)"!="1"
    !@-echo. \
    & echo # *** These are the compiler switches for the XMT model (LIBCMTD.LIB): \
    & echo # \
    & echo # CL = $(CC_OPTS_BASE) \ \
    & echo # $(WINDOWS_H_DEFS) $(FD_REL_MT_DBG) \ \
    & echo # $(MT_DEFINES) \
    & echo # \
    & echo # ML = $(AS_OPTS) \ \
    & echo # $(MT_DEFINES) \
    & echo.
!endif

xmtp_env :
!if "$(PRE_BLD)"!="1" && "$(BLD_LIB)"!="1"
    !@-echo. \
    & echo # *** These are the compiler switches for the XMT model (LIBCPMTD.LIB): \
    & echo # \
    & echo # CL = $(CC_OPTS_BASE) \ \
    & echo # $(WINDOWS_H_DEFS) $(FD_REL_MTP_DBG) \ \
    & echo # $(MT_DEFINES) \
    & echo # \
    & echo # ML = $(AS_OPTS) \ \
    & echo # $(MT_DEFINES) \
    & echo.
!endif

xmt : $(OBJROOT) $(OBJCPUDIR) $(OBJDIR_MT_DBG) $(RELDIR_CPU) \
	$(OBJDIR_MT_DBG)\$(CPP_OBJ_DIR) \
	xmt_env xmt_ xmtp_env xmt_p
!if "$(BLD_BROWSE)"=="1" && "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1"
    $(BSCMAKE) -o $(RELEASE_LIBCMT_DBG:.lib=.bsc) $(OBJDIR_MT_DBG)\*.sbr
!endif

!if "$(BLD_LIB)"!="1"
xmt_ :: $(MAKE_DIRS)
    !@-cd $** \
    & set CL=$(CC_OPTS) $(MT_DEFINES) $(FD_REL_MT_DBG) \
    & set ML=$(AS_OPTS) $(MT_DEFINES) \
    & $(MAKE) -nologo $(IFLAG) -f makefile.sub DIR=$** CPUDIR=$(CPUDIR) \
        WINHEAP=$(WINHEAP) RTC=$(RTC) \
	BLD_REL_NO_DBINFO=$(BLD_REL_NO_DBINFO) \
        BLD_MODEL=xmt BLD_DBG=1 OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_MT_DBG) \
        CPP_OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_MT_DBG)\$(CPP_OBJ_DIR) \
        TARGET_CPU=$(TARGET_CPU) HOST_CPU=$(HOST_CPU) \
        VCTOOLSINC="$(VCTOOLSINC)" \
        PRE_BLD=$(PRE_BLD) POST_BLD=$(POST_BLD) \
    & cd $(CD_ROOT)

!if "$(PRE_BLD)"!="1"
xmt_p :: $(MAKE_DIRSP)
    !@-cd $** \
    & set CL=$(CC_OPTS) $(MT_DEFINES) $(FD_REL_MTP_DBG) \
    & set ML=$(AS_OPTS) $(MT_DEFINES) \
    & $(MAKE) -nologo $(IFLAG) -f makefile.sub DIR=$** CPUDIR=$(CPUDIR) \
        WINHEAP=$(WINHEAP) RTC=$(RTC) \
	BLD_REL_NO_DBINFO=$(BLD_REL_NO_DBINFO) \
        BLD_MODEL=xmt BLD_DBG=1 OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_MT_DBG) \
        CPP_OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_MT_DBG)\$(CPP_OBJ_DIR) \
        TARGET_CPU=$(TARGET_CPU) HOST_CPU=$(HOST_CPU) \
        VCTOOLSINC="$(VCTOOLSINC)" \
        PRE_BLD=$(PRE_BLD) POST_BLD=$(POST_BLD) _stdcpp_ \
    & cd $(CD_ROOT)

!endif
!endif # BLD_LIB != 1

!if "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1"
xmt_ :: $(RELEASE_LIBCMT_DBG)

xmt_p :: $(RELEASE_LIBCPPMT_DBG)
!else
xmt_ ::

xmt_p ::
!endif

xdll_env :
!if "$(BLD_LIB)"!="1"
    !@-echo. \
    & echo # *** These are the compiler switches for the XDLL model (MSVCRTD.LIB): \
    & echo # \
    & echo # CL = $(CC_OPTS_BASE) \ \
    & echo # $(WINDOWS_H_DEFS) $(FD_REL_DLL_DBG) \ \
    & echo # $(DLL_DEFINES) \
    & echo # \
    & echo # ML = $(AS_OPTS) \ \
    & echo # $(DLL_DEFINES) \
    & echo.
!endif

xdllp_env :
!if "$(PRE_BLD)"!="1" && "$(BLD_LIB)"!="1"
    !@-echo. \
    & echo # *** These are the compiler switches for the XDLL model (MSVCPRTD.LIB): \
    & echo # \
    & echo # CL = $(CC_OPTS_BASE) \ \
    & echo # $(WINDOWS_H_DEFS) $(FD_REL_DLLP_DBG) \ \
    & echo # $(DLLCPP_DEFINES) \
    & echo # \
    & echo # ML = $(AS_OPTS) \ \
    & echo # $(DLLCPP_DEFINES) \
    & echo.

!endif

xdll : $(OBJROOT) $(OBJCPUDIR) $(OBJDIR_DLL_DBG) \
    $(OBJDIR_DLL_DBG)\$(CPP_OBJ_DIR) $(RELDIR_CPU) \
	xothers xdll_env xdll_ \
	 xdllp_env xdll_p
!if "$(BLD_BROWSE)"=="1" && "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1"
    $(BSCMAKE) -o $(RELEASE_IMPLIB_DLL_DBG:.lib=.bsc) $(OBJDIR_DLL_DBG)\*.sbr
!endif

!if "$(BLD_LIB)"!="1"
xdll_ :: $(MAKE_DIRS_DLL)
    !@-cd $** \
    & set CL=$(CC_OPTS) $(DLL_DEFINES) $(FD_REL_DLL_DBG) \
    & set ML=$(AS_OPTS) $(DLL_DEFINES) \
    & $(MAKE) -nologo $(IFLAG) -f makefile.sub DIR=$** CPUDIR=$(CPUDIR) \
        WINHEAP=$(WINHEAP) RTC=$(RTC) \
	BLD_REL_NO_DBINFO=$(BLD_REL_NO_DBINFO) \
        BLD_MODEL=xdll BLD_DLL=1 BLD_DBG=1 OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_DLL_DBG) \
        CPP_OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_DLL_DBG)\$(CPP_OBJ_DIR) \
        TARGET_CPU=$(TARGET_CPU) HOST_CPU=$(HOST_CPU) \
        VCTOOLSINC="$(VCTOOLSINC)" \
        PRE_BLD=$(PRE_BLD) POST_BLD=$(POST_BLD) \
    & cd $(CD_ROOT)

!if "$(PRE_BLD)"!="1"
xdll_p :: $(MAKE_DIRSP_DLL)
    !@-cd $** \
    & set CL=$(CC_OPTS) $(DLLCPP_DEFINES) $(FD_REL_DLLP_DBG) \
    & set ML=$(AS_OPTS) $(DLLCPP_DEFINES) \
    & $(MAKE) -nologo $(IFLAG) -f makefile.sub DIR=$** CPUDIR=$(CPUDIR) \
        WINHEAP=$(WINHEAP) RTC=$(RTC) \
	BLD_REL_NO_DBINFO=$(BLD_REL_NO_DBINFO) \
        BLD_MODEL=xdll BLD_DLL=1 BLD_DBG=1 OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_DLL_DBG) \
        CPP_OBJDIR=$(OBJDIR_PREFIX)$(OBJDIR_DLL_DBG)\$(CPP_OBJ_DIR) \
        TARGET_CPU=$(TARGET_CPU) HOST_CPU=$(HOST_CPU) \
        VCTOOLSINC="$(VCTOOLSINC)" \
        PRE_BLD=$(PRE_BLD) POST_BLD=$(POST_BLD) _stdcpp_ \
    & cd $(CD_ROOT)

!endif
!endif # BLD_LIB != 1

!if "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1"
xdll_ :: $(RELEASE_DLL_DBG)

xdll_p :: $(RELEASE_DLLCPP_DBG)

!else
xdll_ ::

xdll_p ::

!endif


all_link: st_link mt_link dll_link

st_link: $(RELEASE_LIBCST) $(RELEASE_LIBCPPST)

mt_link: $(RELEASE_LIBCMT) $(RELEASE_LIBCPPMT)

dll_link: $(RELEASE_DLL) $(RELEASE_DLLCPP)



oldnames :

others :

xothers :

#
##
## Make Process for Compiler Helper Libraries
##
################################################################################
#
#$(RELEASE_CHELPER): $(RELDIR_CPU) build\$(CPUDIR)\st_obj\helper.lib
#	$(LINKLIB) -out:$@ build\$(CPUDIR)\st_obj\helper.lib
#

#
# Make Process for Static Libraries
#
###############################################################################

$(RELEASE_LIBCST): $(RELDIR_CPU) $(SOURCE_OBJS:*=st) \
 $(OBJDIR_ST)\link.rsp
	$(LINKLIB) -out:$@ @$(OBJDIR_ST)\link.rsp

$(RELEASE_LIBCPPST): $(RELDIR_CPU) $(CPPSRC_OBJS:*=st) \
 $(OBJDIR_ST)\linkcpp.rsp
	$(LINKLIB) -out:$@ @$(OBJDIR_ST)\linkcpp.rsp

!if "$(BLD_OBJ)"!="1"
$(OBJDIR_ST)\link.rsp: makefile
	@echo *** Creating linker response file <<$@
$(SOURCE_OBJS:*=st)
<<keep

$(OBJDIR_ST)\linkcpp.rsp: makefile
	@echo *** Creating linker response file <<$@
$(CPPSRC_OBJS:*=st)
<<keep

!endif


$(RELEASE_LIBCST_DBG): $(RELDIR_CPU) $(SOURCE_OBJS:*=xst) \
 $(OBJDIR_ST_DBG)\link.rsp
	$(LINKLIB) -out:$@ @$(OBJDIR_ST_DBG)\link.rsp

$(RELEASE_LIBCPPST_DBG): $(RELDIR_CPU) $(CPPSRC_OBJS:*=xst) \
 $(OBJDIR_ST_DBG)\linkcpp.rsp
	$(LINKLIB) -out:$@ @$(OBJDIR_ST_DBG)\linkcpp.rsp

!if "$(BLD_OBJ)"!="1"
$(OBJDIR_ST_DBG)\link.rsp: makefile
	@echo *** Creating linker response file <<$@
$(SOURCE_OBJS:*=xst)
<<keep

$(OBJDIR_ST_DBG)\linkcpp.rsp: makefile
	@echo *** Creating linker response file <<$@
$(CPPSRC_OBJS:*=xst)
<<keep

!endif


$(RELEASE_LIBCMT): $(RELDIR_CPU) $(SOURCE_OBJS:*=mt) \
 $(OBJDIR_MT)\link.rsp
	$(LINKLIB) $(ADDITIONAL_LINK_OPT) -out:$@ @$(OBJDIR_MT)\link.rsp

$(RELEASE_LIBCPPMT): $(RELDIR_CPU) $(CPPSRC_OBJS:*=mt) \
 $(OBJDIR_MT)\linkcpp.rsp
	$(LINKLIB) -out:$@ @$(OBJDIR_MT)\linkcpp.rsp

!if "$(BLD_OBJ)"!="1"
$(OBJDIR_MT)\link.rsp: makefile
	@echo *** Creating linker response file <<$@
$(SOURCE_OBJS:*=mt)
<<keep

$(OBJDIR_MT)\linkcpp.rsp: makefile
	@echo *** Creating linker response file <<$@
$(CPPSRC_OBJS:*=mt)
<<keep

!endif


$(RELEASE_LIBCMT_DBG): $(RELDIR_CPU) $(SOURCE_OBJS:*=xmt) \
 $(OBJDIR_MT_DBG)\link.rsp
	$(LINKLIB) $(ADDITIONAL_LINK_OPT) -out:$@ @$(OBJDIR_MT_DBG)\link.rsp

$(RELEASE_LIBCPPMT_DBG): $(RELDIR_CPU) $(CPPSRC_OBJS:*=xmt) \
 $(OBJDIR_MT_DBG)\linkcpp.rsp
	$(LINKLIB) -out:$@ @$(OBJDIR_MT_DBG)\linkcpp.rsp

!if "$(BLD_OBJ)"!="1"
$(OBJDIR_MT_DBG)\link.rsp: makefile
	@echo *** Creating linker response file <<$@
$(SOURCE_OBJS:*=xmt)
<<keep

$(OBJDIR_MT_DBG)\linkcpp.rsp: makefile
	@echo *** Creating linker response file <<$@
$(CPPSRC_OBJS:*=xmt)
<<keep

!endif


#
# Make Process for C Run-Time DLL
#
###############################################################################

# todo ... preprocess a single source .def file into machine-specific version

OBJS_WITH_EXPORTS_DLL_RAW= \
        $(OBJDIR_DLL_RAW)\handler.obj \
        $(OBJDIR_DLL_RAW)\setnewh.obj \
        $(OBJDIR_DLL_RAW)\new_mode.obj \
        $(OBJDIR_DLL_RAW)\errmode.obj \
        $(OBJDIR_DLL_RAW)\matherr.obj


OBJS_WITH_EXPORTS_DLL=$(OBJS_WITH_EXPORTS_DLL_RAW:*=dll)

OBJS_WITH_EXPORTS_DLL_DBG=$(OBJS_WITH_EXPORTS_DLL_RAW:*=xdll) $(OBJDIR_DLL_RAW:*=xdll)\dbgnew.obj

# These are the C++ objects in MSVCPRT{,D}.LIB

DLLCPP_STATIC_OBJS_RAW= \
	$(OBJDIR_DLL_RAW)\nothrow.obj   \
	$(OBJDIR_DLL_RAW)\newaop_s.obj  \


DLLCPP_STATIC_OBJS=$(DLLCPP_STATIC_OBJS_RAW:*=dll)

DLLCPP_STATIC_OBJS_DBG=$(DLLCPP_STATIC_OBJS_RAW:*=xdll)


# These are the C++ objects in MSVCPXX{,D}.DLL which have exports

OBJS_WITH_EXPORTS_DLLCPP_RAW= \
	$(OBJDIR_DLL_RAW)\badfunction.obj \
	$(OBJDIR_DLL_RAW)\badweakptr.obj \
	$(OBJDIR_DLL_RAW)\multprec.obj \
	$(OBJDIR_DLL_RAW)\regex.obj \
	$(OBJDIR_DLL_RAW)\xinvalid.obj \
	$(OBJDIR_DLL_RAW)\xlgamma.obj \
	$(OBJDIR_DLL_RAW)\xoutrange.obj \
	$(OBJDIR_DLL_RAW)\xrngabort.obj \
	$(OBJDIR_DLL_RAW)\xrngdev.obj \
	$(OBJDIR_DLL_RAW)\cerr.obj \
	$(OBJDIR_DLL_RAW)\cin.obj \
	$(OBJDIR_DLL_RAW)\clog.obj \
	$(OBJDIR_DLL_RAW)\cout.obj \
	$(OBJDIR_DLL_RAW)\dbgsec.obj \
	$(OBJDIR_DLL_RAW)\fiopen.obj \
	$(OBJDIR_DLL_RAW)\instances.obj \
	$(OBJDIR_DLL_RAW)\iomanip.obj \
	$(OBJDIR_DLL_RAW)\iosptrs.obj \
	$(OBJDIR_DLL_RAW)\iostream.obj \
	$(OBJDIR_DLL_RAW)\locale.obj \
	$(OBJDIR_DLL_RAW)\nomemory.obj \
	$(OBJDIR_DLL_RAW)\raisehan.obj \
	$(OBJDIR_DLL_RAW)\stdhndlr.obj \
	$(OBJDIR_DLL_RAW)\stdthrow.obj \
	$(OBJDIR_DLL_RAW)\string.obj \
	$(OBJDIR_DLL_RAW)\strstrea.obj \
	$(OBJDIR_DLL_RAW)\ushcerr.obj \
	$(OBJDIR_DLL_RAW)\ushcout.obj \
	$(OBJDIR_DLL_RAW)\ushcin.obj \
	$(OBJDIR_DLL_RAW)\ushclog.obj \
	$(OBJDIR_DLL_RAW)\ushiostr.obj \
	$(OBJDIR_DLL_RAW)\uncaught.obj \
	$(OBJDIR_DLL_RAW)\wcerr.obj \
	$(OBJDIR_DLL_RAW)\wcin.obj \
	$(OBJDIR_DLL_RAW)\wclog.obj \
	$(OBJDIR_DLL_RAW)\wcout.obj \
	$(OBJDIR_DLL_RAW)\wctrans.obj \
	$(OBJDIR_DLL_RAW)\wctype.obj \
	$(OBJDIR_DLL_RAW)\wiostrea.obj \
	$(OBJDIR_DLL_RAW)\xmbtowc.obj \
	$(OBJDIR_DLL_RAW)\xstrcoll.obj \
	$(OBJDIR_DLL_RAW)\xstrxfrm.obj \
	$(OBJDIR_DLL_RAW)\xwctomb.obj


OBJS_WITH_EXPORTS_DLLCPP=$(OBJS_WITH_EXPORTS_DLLCPP_RAW:*=dll)

OBJS_WITH_EXPORTS_DLLCPP_DBG=$(OBJS_WITH_EXPORTS_DLLCPP_RAW:*=xdll)

DLL_MT_OBJS_RAW= \
        $(OBJDIR_DLL_RAW)\_newmode.obj \
!if "$(TARGET_CPU)"=="i386"
        $(OBJDIR_DLL_RAW)\alloca16.obj \
        $(OBJDIR_DLL_RAW)\atlssup.obj \
!endif
        $(OBJDIR_DLL_RAW)\charmax.obj \
        $(OBJDIR_DLL_RAW)\chkstk.obj \
!if "$(TARGET_CPU)"=="AMD64"
        $(OBJDIR_DLL_RAW)\chkstk2.obj   \
!endif
        $(OBJDIR_DLL_RAW)\xncommod.obj \
        $(OBJDIR_DLL_RAW)\tlssup.obj \
        $(OBJDIR_DLL_RAW)\tlsdyn.obj \
        $(OBJDIR_DLL_RAW)\tlsdtor.obj \
        $(OBJDIR_DLL_RAW)\xtxtmode.obj \
        $(OBJDIR_DLL_RAW)\xthdloc.obj


DLL_STATIC_OBJS_RAW= \
        $(OBJDIR_DLL_RAW)\atonexit.obj \
        $(OBJDIR_DLL_RAW)\cinitexe.obj \
        $(OBJDIR_DLL_RAW)\crtdll.obj \
        $(OBJDIR_DLL_RAW)\crtexe.obj \
        $(OBJDIR_DLL_RAW)\crtmanifest.obj \
        $(OBJDIR_DLL_RAW)\crtmanifestrtm.obj \
        $(OBJDIR_DLL_RAW)\crtmanifestcur.obj \
        $(OBJDIR_DLL_RAW)\crtexew.obj \
        $(OBJDIR_DLL_RAW)\delaopnt.obj \
        $(OBJDIR_DLL_RAW)\delopnt.obj \
        $(OBJDIR_DLL_RAW)\dll_argv.obj \
        $(OBJDIR_DLL_RAW)\dllargv.obj \
        $(OBJDIR_DLL_RAW)\dllmain.obj \
        $(OBJDIR_DLL_RAW)\ehvccctr.obj \
        $(OBJDIR_DLL_RAW)\ehvcccvb.obj \
        $(OBJDIR_DLL_RAW)\ehvecctr.obj \
        $(OBJDIR_DLL_RAW)\ehveccvb.obj \
        $(OBJDIR_DLL_RAW)\ehvecdtr.obj \
        $(OBJDIR_DLL_RAW)\gs_cookie.obj \
        $(OBJDIR_DLL_RAW)\gs_report.obj \
        $(OBJDIR_DLL_RAW)\gs_support.obj \
!if "$(BLD_SYSCRT)" != "1"
        $(OBJDIR_DLL_RAW)\tncleanup.obj \
!endif
        $(OBJDIR_DLL_RAW)\merr.obj \
        $(OBJDIR_DLL_RAW)\newaopnt.obj \
        $(OBJDIR_DLL_RAW)\newopnt.obj \
        $(OBJDIR_DLL_RAW)\nothrow0.obj \
        $(OBJDIR_DLL_RAW)\natstart.obj \
        $(OBJDIR_DLL_RAW)\pesect.obj \
        $(OBJDIR_DLL_RAW)\ti_inst.obj \
        $(OBJDIR_DLL_RAW)\unhandld.obj \
        $(OBJDIR_DLL_RAW)\wcrtexe.obj \
        $(OBJDIR_DLL_RAW)\wcrtexew.obj \
        $(OBJDIR_DLL_RAW)\wdll_av.obj \
        $(OBJDIR_DLL_RAW)\wdllargv.obj \
        $(OBJDIR_DLL_RAW)\wildcard.obj \
!if "$(RTC)"=="YES"
        $(OBJDIR_DLL_RAW)\rtc.lib \
!endif
!if "$(TARGET_CPU)"=="i386"
        $(OBJDIR_DLL_RAW)\adjustfd.obj \
        $(OBJDIR_DLL_RAW)\chandler4gs.obj \
        $(OBJDIR_DLL_RAW)\cpu_disp.obj \
        $(OBJDIR_DLL_RAW)\dllsupp.obj \
        $(OBJDIR_DLL_RAW)\ehprolg2.obj \
        $(OBJDIR_DLL_RAW)\ehprolg3.obj \
        $(OBJDIR_DLL_RAW)\ehprolg3a.obj \
        $(OBJDIR_DLL_RAW)\ehprolog.obj \
        $(OBJDIR_DLL_RAW)\fp8.obj \
        $(OBJDIR_DLL_RAW)\ftol2.obj \
        $(OBJDIR_DLL_RAW)\lldiv.obj \
        $(OBJDIR_DLL_RAW)\lldvrm.obj \
        $(OBJDIR_DLL_RAW)\llmul.obj \
        $(OBJDIR_DLL_RAW)\llrem.obj \
        $(OBJDIR_DLL_RAW)\llshl.obj \
        $(OBJDIR_DLL_RAW)\llshr.obj \
        $(OBJDIR_DLL_RAW)\loadcfg.obj \
        $(OBJDIR_DLL_RAW)\secchk.obj \
        $(OBJDIR_DLL_RAW)\sehprolg.obj \
        $(OBJDIR_DLL_RAW)\sehprolg4.obj \
        $(OBJDIR_DLL_RAW)\sehprolg4gs.obj \
        $(OBJDIR_DLL_RAW)\ulldiv.obj \
        $(OBJDIR_DLL_RAW)\ulldvrm.obj \
        $(OBJDIR_DLL_RAW)\ullrem.obj \
        $(OBJDIR_DLL_RAW)\ullshr.obj \
!elseif "$(TARGET_CPU)"=="AMD64"
        $(OBJDIR_DLL_RAW)\amdsecgs.obj \
        $(OBJDIR_DLL_RAW)\dllsupp.obj \
        $(OBJDIR_DLL_RAW)\gshandler.obj \
        $(OBJDIR_DLL_RAW)\gshandlereh.obj \
        $(OBJDIR_DLL_RAW)\gshandlerseh.obj \
!elseif "$(TARGET_CPU)"=="IA64"
        $(OBJDIR_DLL_RAW)\dllsupp.obj \
        $(OBJDIR_DLL_RAW)\divhelp.obj \
        $(OBJDIR_DLL_RAW)\gshandler.obj \
        $(OBJDIR_DLL_RAW)\gshandlereh.obj \
        $(OBJDIR_DLL_RAW)\gshandlerseh.obj \
        $(OBJDIR_DLL_RAW)\memcmp.obj \
        $(OBJDIR_DLL_RAW)\memcpy.obj \
        $(OBJDIR_DLL_RAW)\memcpyi.obj \
        $(OBJDIR_DLL_RAW)\memmove.obj \
        $(OBJDIR_DLL_RAW)\memset.obj \
        $(OBJDIR_DLL_RAW)\memseti.obj \
        $(OBJDIR_DLL_RAW)\secchk.obj \
        $(OBJDIR_DLL_RAW)\strncmp.obj \
        $(OBJDIR_DLL_RAW)\strncpy.obj
!endif

DLL_STATIC_OBJS=$(DLL_MT_OBJS_RAW:*=dll) $(DLL_STATIC_OBJS_RAW:*=dll)

DLL_STATIC_OBJS_DBG=$(DLL_MT_OBJS_RAW:*=xdll) $(DLL_STATIC_OBJS_RAW:*=xdll)


!if "$(POST_BLD)"!="1"

$(DEFFILE_DIR)\$(RETAIL_LIB_NAME).def : $(RC_NAME).src
	@echo.
	@echo *** Creating file $@ from $**
        $(CC) -nologo                                                          \
        -DBOOT_EXPORTS                                                         \
        -DLIBRARYNAME=$(RETAIL_DLL_NAME_UC)                                    \
        $(DLL_DEFINES)                                                         \
        -EP -Tc$(RC_NAME).src | sed "/^[ 	]*$$/d" > $@

$(DEFFILE_DIR)\$(DEBUG_LIB_NAME).def : $(RC_NAME).src
	@echo.
	@echo *** Creating file $@ from $**
        $(CC) -nologo                                                          \
        -DBOOT_EXPORTS                                                         \
        -DLIBRARYNAME=$(DEBUG_DLL_NAME_UC)                                     \
        $(DLL_DEFINES)                                                         \
        -D_DEBUG -EP -Tc$(RC_NAME).src | sed "/^[ 	]*$$/d" > $@

$(DEFFILE_DIR)\$(RETAIL_FWDRDLL_NAME).def : $(RETAIL_FWDRDLL_NAME).src
	@echo.
	@echo *** Creating file $@ from $**
        $(CC) -nologo -EP -Tc$(RETAIL_FWDRDLL_NAME).src | sed "/^[ 	]*$$/d" > $@

$(DEFFILE_DIR)\$(DEBUG_FWDRDLL_NAME).def : $(RETAIL_FWDRDLL_NAME).src
	@echo.
	@echo *** Creating file $@ from $**
        $(CC) -nologo -D_DEBUG -EP -Tc$(RETAIL_FWDRDLL_NAME).src | sed "/^[ 	]*$$/d" > $@

$(DEFFILE2_DIR)\$(RETAIL_LIBCPP_NAME).def : $(RCCPP_NAME).src
	@echo.
	@echo *** Creating file $@ from $**
        $(CC) -nologo -DLIBRARYNAME=$(RETAIL_DLLCPP_NAME_UC) -DBASECRT=$(RETAIL_DLL_NAME_UC) $(DLLCPP_DEFINES) -EP -Tc$(RCCPP_NAME).src | sed "/^[ 	]*$$/d" > $@

$(DEFFILE2_DIR)\$(DEBUG_LIBCPP_NAME).def : $(RCCPP_NAME).src
	@echo.
	@echo *** Creating file $@ from $**
        $(CC) -nologo -DLIBRARYNAME=$(DEBUG_DLLCPP_NAME_UC) -DBASECRT=$(DEBUG_DLL_NAME_UC) $(DLLCPP_DEFINES) -D_DEBUG -EP -Tc$(RCCPP_NAME).src | sed "/^[ 	]*$$/d" > $@


!endif


# MSVCRXX.DLL / MSVCRT.LIB

$(RELEASE_DLL) : $(RELDIR_CPU) $(RC_NAME).rc \
 $(DEFFILE_DIR)\$(RETAIL_LIB_NAME).def $(SOURCE_OBJS_DLL:*=dll) \
 $(DLL_STATIC_OBJS) $(SDKNAMESLIB_DIR)\sdknames.lib \
 $(ALMAPLIB_DIR)\almap.lib \
 $(TCMAPLIB_DIR)\tcmap.lib $(TCMAPDLLLIB_DIR)\tcmapdll.lib $(ALMAPDLLLIB_DIR)\almapdll.lib \
 "$(VCTOOLSINC)\winver.h" \
# !if "$(BLD_SYSCRT)" == "1"
# $(OBJDIR_DLL)\link.rsp $(OBJDIR_DLL)\implib.rsp
# !else
 $(OBJDIR_DLL)\link.rsp $(OBJDIR_DLL)\implib.rsp
# !endif
	rc $(RC_OPTS) -Fo $(@R).res $(RC_DEFS) $(RC_INCS) $(RC_NAME).rc
	$(LINKER) @$(OBJDIR_DLL)\link.rsp
	$(LINKIMPLIB) @$(OBJDIR_DLL)\implib.rsp

!if "$(BLD_OBJ)"!="1"
$(OBJDIR_DLL)\link.rsp: makefile
	@echo *** Creating linker response file <<$@
!if "$(TARGET_CPU)" == "i386"
-base:0x78520000
!endif
!if "$(TARGET_CPU)" == "IA64"
-base:0x788a0000
!endif
!if "$(TARGET_CPU)" == "AMD64"
-base:0x78620000
!endif
!if "$(BLD_REL_NO_DBINFO)" != "1"
-debug
-pdb:$(RELEASE_DLL_PDB)
!endif
-def:$(DEFFILE_DIR)\$(RETAIL_LIB_NAME).def
-dll
-entry:_CRTDLL_INIT
-implib:$(OBJDIR_DLL)\tmp.lib
-opt:ref,icf=3
-incremental:no
!if "$(LLP64)"=="1"
-osversion:5.00
-subsystem:WINDOWS,5.01
!endif
-map
-out:$(RELEASE_DLL)
-release
-nodefaultlib:libcpmt.lib
$(OBJS_WITH_EXPORTS_DLL)
$(RELEASE_DLL:.dll=.res)
$(SOURCE_OBJS_DLL:*=dll)
kernel32.lib
<<keep

$(OBJDIR_DLL)\implib.rsp: makefile
	@echo *** Creating linker response file <<$@
-out:$(RELEASE_IMPLIB_DLL)
$(OBJDIR_DLL)\tmp.lib
$(DLL_STATIC_OBJS)
$(SDKNAMESLIB_DIR)\sdknames.lib
$(TCMAPLIB_DIR)\tcmap.lib
$(TCMAPDLLLIB_DIR)\tcmapdll.lib
$(ALMAPLIB_DIR)\almap.lib
$(ALMAPDLLLIB_DIR)\almapdll.lib
<<keep
!endif


# MSVCPXX.DLL / MSVCPRT.LIB

$(RELEASE_DLLCPP) : $(RELDIR_CPU) $(RCCPP_NAME).rc \
 $(DEFFILE2_DIR)\$(RETAIL_LIBCPP_NAME).def $(CPPSRC_OBJS_DLL:*=dll) \
 $(DLLCPP_STATIC_OBJS) \
 "$(VCTOOLSINC)\winver.h" \
 $(RELEASE_IMPLIB_DLL) \
# !if "$(BLD_SYSCRT)" == "1"
# $(OBJDIR_DLL)\linkp.rsp $(OBJDIR_DLL)\implibp.rsp
# !else
 $(OBJDIR_DLL)\linkp.rsp $(OBJDIR_DLL)\implibp.rsp $(OBJDIR_DLL)\implibp.rsp
# !endif
	rc $(RC_OPTS) -Fo $(@R).res $(RC_DEFS) $(RC_INCS) $(RCCPP_NAME).rc
	$(LINKER) @$(OBJDIR_DLL)\linkp.rsp
	$(LINKIMPLIB) @$(OBJDIR_DLL)\implibp.rsp

!if "$(BLD_OBJ)"!="1"
$(OBJDIR_DLL)\linkp.rsp: makefile
	@echo *** Creating linker response file <<$@
!if "$(TARGET_CPU)" == "i386"
-base:0x78480000
!endif
!if "$(TARGET_CPU)" == "IA64"
-base:0x78700000
!endif
!if "$(TARGET_CPU)" == "AMD64"
-base:0x78520000
!endif
!if "$(BLD_REL_NO_DBINFO)" != "1"
-debug
-pdb:$(RELEASE_DLLCPP_PDB)
!endif
-def:$(DEFFILE2_DIR)\$(RETAIL_LIBCPP_NAME).def
-dll
-opt:ref,icf=3
-implib:$(OBJDIR_DLL)\tmpp.lib
-incremental:no
!if "$(LLP64)"=="1"
-osversion:5.00
-subsystem:WINDOWS,5.01
!endif
-map
-out:$(RELEASE_DLLCPP)
-release
-nodefaultlib:$(RETAIL_LIBCPP_NAME).lib
-nodefaultlib:libcpmt.lib
$(OBJS_WITH_EXPORTS_DLLCPP)
$(RELEASE_DLLCPP:.dll=.res)
$(CPPSRC_OBJS_DLL:*=dll)
$(RELEASE_IMPLIB_DLL)
kernel32.lib
<<keep

$(OBJDIR_DLL)\implibp.rsp: makefile
	@echo *** Creating linker response file <<$@
-out:$(RELEASE_IMPLIB_DLLCPP)
$(OBJDIR_DLL)\tmpp.lib
$(DLLCPP_STATIC_OBJS)
<<keep
!endif


# MSVCRXXD.DLL / MSVCRTD.LIB

$(RELEASE_DLL_DBG) : $(RELDIR_CPU) $(RC_NAME).rc \
 $(DEFFILE_DIR)\$(DEBUG_LIB_NAME).def $(SOURCE_OBJS_DLL:*=xdll) \
 $(DLL_STATIC_OBJS_DBG) $(SDKNAMESLIB_DIR)\sdknames.lib \
 $(ALMAPLIB_DIR)\almap.lib \
 $(TCMAPLIB_DIR)\tcmap.lib $(TCMAPDLLLIB_DIR)\tcmapdll.lib $(ALMAPDLLLIB_DIR)\almapdll.lib \
 "$(VCTOOLSINC)\winver.h" \
# !if "$(BLD_SYSCRT)" == "1"
# $(OBJDIR_DLL_DBG)\link.rsp $(OBJDIR_DLL_DBG)\implib.rsp
# !else
 $(OBJDIR_DLL_DBG)\link.rsp $(OBJDIR_DLL_DBG)\implib.rsp
# !endif
	rc $(RC_OPTS) -Fo $(@R).res -D_DEBUG $(RC_DEFS) $(RC_INCS) $(RC_NAME).rc
	$(LINKER) @$(OBJDIR_DLL_DBG)\link.rsp
	$(LINKIMPLIB) @$(OBJDIR_DLL_DBG)\implib.rsp

!if "$(BLD_OBJ)"!="1"
$(OBJDIR_DLL_DBG)\link.rsp: makefile
	@echo *** Creating linker response file <<$@
-base:0x10200000
-debug
-def:$(DEFFILE_DIR)\$(DEBUG_LIB_NAME).def
-dll
-entry:_CRTDLL_INIT
-implib:$(OBJDIR_DLL_DBG)\tmp.lib
-incremental:no
!if "$(LLP64)"=="1"
-osversion:5.00
-subsystem:WINDOWS,5.01
!endif
-map
-opt:ref,icf=3
-out:$(RELEASE_DLL_DBG)
-release
-nodefaultlib:libcpmtd.lib
-pdb:$(RELEASE_DLL_DBG_PDB)
$(OBJS_WITH_EXPORTS_DLL_DBG)
$(RELEASE_DLL_DBG:.dll=.res)
$(SOURCE_OBJS_DLL:*=xdll)
kernel32.lib
<<keep

$(OBJDIR_DLL_DBG)\implib.rsp: makefile
	@echo *** Creating linker response file <<$@
-out:$(RELEASE_IMPLIB_DLL_DBG)
$(OBJDIR_DLL_DBG)\tmp.lib
$(DLL_STATIC_OBJS_DBG)
$(SDKNAMESLIB_DIR)\sdknames.lib
$(TCMAPLIB_DIR)\tcmap.lib
$(TCMAPDLLLIB_DIR)\tcmapdll.lib
$(ALMAPLIB_DIR)\almap.lib
$(ALMAPDLLLIB_DIR)\almapdll.lib
<<keep
!endif


#!endif

# MSVCPXXD.DLL / MSVCPRTD.LIB

$(RELEASE_DLLCPP_DBG) : $(RELDIR_CPU) $(RCCPP_NAME).rc \
 $(DEFFILE2_DIR)\$(DEBUG_LIBCPP_NAME).def $(CPPSRC_OBJS_DLL:*=xdll) \
 $(DLLCPP_STATIC_OBJS_DBG) \
 "$(VCTOOLSINC)\winver.h" \
 $(RELEASE_IMPLIB_DLL_DBG) \
# !if "$(BLD_SYSCRT)" == "1"
# $(OBJDIR_DLL_DBG)\linkp.rsp $(OBJDIR_DLL_DBG)\implibp.rsp
# !else
 $(OBJDIR_DLL_DBG)\linkp.rsp $(OBJDIR_DLL_DBG)\implibp.rsp
# !endif
	rc $(RC_OPTS) -Fo $(@R).res -D_DEBUG $(RC_DEFS) $(RC_INCS) $(RCCPP_NAME).rc
	$(LINKER) @$(OBJDIR_DLL_DBG)\linkp.rsp
	$(LINKIMPLIB) @$(OBJDIR_DLL_DBG)\implibp.rsp

!if "$(BLD_OBJ)"!="1"
$(OBJDIR_DLL_DBG)\linkp.rsp: makefile
	@echo *** Creating linker response file <<$@
-base:0x10480000
-debug
-def:$(DEFFILE2_DIR)\$(DEBUG_LIBCPP_NAME).def
-dll
-implib:$(OBJDIR_DLL_DBG)\tmpp.lib
-incremental:no
!if "$(LLP64)"=="1"
-osversion:5.00
-subsystem:WINDOWS,5.01
!endif
-map
-opt:ref,icf=3
-out:$(RELEASE_DLLCPP_DBG)
-release
-nodefaultlib:$(DEBUG_LIBCPP_NAME).lib
-nodefaultlib:libcpmtd.lib
-pdb:$(RELEASE_DLLCPP_DBG_PDB)
$(OBJS_WITH_EXPORTS_DLLCPP_DBG)
$(RELEASE_DLLCPP_DBG:.dll=.res)
$(CPPSRC_OBJS_DLL:*=xdll)
$(RELEASE_IMPLIB_DLL_DBG)
kernel32.lib
<<keep

$(OBJDIR_DLL_DBG)\implibp.rsp: makefile
	@echo *** Creating linker response file <<$@
-out:$(RELEASE_IMPLIB_DLLCPP_DBG)
$(DLLCPP_STATIC_OBJS_DBG)
$(OBJDIR_DLL_DBG)\tmpp.lib
<<keep
!endif



####
#
# Compiler Helper Library
#
####

!if "$(POST_BLD)"=="1"

compiler_helper_lib: $(RELEASE_CHELPER)

CHELPER_OBJ= \
        $(OBJDIR_DLL)\ehvccctr.obj  \
        $(OBJDIR_DLL)\ehvcccvb.obj  \
        $(OBJDIR_DLL)\ehvecctr.obj  \
        $(OBJDIR_DLL)\ehveccvb.obj  \
        $(OBJDIR_DLL)\ehvecdtr.obj  \
        $(OBJDIR_DLL)\chkstk.obj    \
        $(OBJDIR_DLL)\gs_cookie.obj \
        $(OBJDIR_DLL)\gs_report.obj \
        $(OBJDIR_DLL)\gs_support.obj \
        $(OBJDIR_DLL)\pesect.obj \
!if "$(TARGET_CPU)"=="i386"
        $(OBJDIR_DLL)\alloca16.obj \
        $(OBJDIR_DLL)\chandler4.obj \
        $(OBJDIR_DLL)\chandler4gs.obj \
        $(OBJDIR_DLL)\cpu_disp.obj \
        $(OBJDIR_DLL)\ehprolg2.obj \
        $(OBJDIR_DLL)\ehprolg3.obj \
        $(OBJDIR_DLL)\ehprolg3a.obj \
        $(OBJDIR_DLL)\ehprolog.obj \
        $(OBJDIR_DLL)\exsup.obj \
        $(OBJDIR_DLL)\exsup3.obj \
        $(OBJDIR_DLL)\exsup4.obj \
        $(OBJDIR_DLL)\fp8.obj \
        $(OBJDIR_DLL)\ftol2.obj \
        $(OBJDIR_DLL)\lldiv.obj \
        $(OBJDIR_DLL)\lldvrm.obj \
        $(OBJDIR_DLL)\llmul.obj \
        $(OBJDIR_DLL)\llrem.obj \
        $(OBJDIR_DLL)\llshl.obj \
        $(OBJDIR_DLL)\llshr.obj \
        $(OBJDIR_DLL)\loadcfg.obj \
        $(OBJDIR_DLL)\secchk.obj \
        $(OBJDIR_DLL)\sehprolg.obj \
        $(OBJDIR_DLL)\sehprolg4.obj \
        $(OBJDIR_DLL)\sehprolg4gs.obj \
        $(OBJDIR_DLL)\ulldiv.obj \
        $(OBJDIR_DLL)\ulldvrm.obj \
        $(OBJDIR_DLL)\ullrem.obj \
        $(OBJDIR_DLL)\ullshr.obj \
!elseif "$(TARGET_CPU)"=="AMD64"
        $(OBJDIR_DLL)\amdsecgs.obj \
        $(OBJDIR_DLL)\chkstk2.obj   \
        $(OBJDIR_DLL)\gshandler.obj \
        $(OBJDIR_DLL)\gshandlerseh.obj \
!elseif "$(TARGET_CPU)"=="IA64"
        $(OBJDIR_DLL)\divhelp.obj \
        $(OBJDIR_DLL)\gshandler.obj \
        $(OBJDIR_DLL)\gshandlerseh.obj \
        $(OBJDIR_DLL)\memcmp.obj \
        $(OBJDIR_DLL)\memcpy.obj \
        $(OBJDIR_DLL)\memcpyi.obj \
        $(OBJDIR_DLL)\memmove.obj \
        $(OBJDIR_DLL)\memset.obj \
        $(OBJDIR_DLL)\memseti.obj \
        $(OBJDIR_DLL)\secchk.obj \
        $(OBJDIR_DLL)\strncmp.obj \
        $(OBJDIR_DLL)\strncpy.obj \
!endif


$(RELEASE_CHELPER): $(RELDIR_CPU) $(CHELPER_OBJ) $(OBJDIR_DLL)\chelplnk.rsp
	$(LINKLIB) -out:$@ @$(OBJDIR_DLL)\chelplnk.rsp


$(OBJDIR_DLL)\chelplnk.rsp: makefile
	@echo *** Creating linker response file <<$@
$(CHELPER_OBJ)
<<keep

!else

compiler_helper_lib:

!endif

####
#
# safecrt library
#
####
!if "$(POST_BLD)"=="1"

safecrt_lib: $(RELEASE_SAFECRT)

$(RELEASE_SAFECRT): $(RELDIR_CPU) $(CPUDIR)\$(MT_LIB_DIR)\safecrt.lib
	@copy $(CPUDIR)\$(MT_LIB_DIR)\safecrt.lib $@

!else

safecrt_lib:

!endif

####
#
# Release objects
#
####

!if "$(POST_BLD)"=="1" && "$(BLD_OBJ)"=="1"

relobjs:

!else

relobjs: \
!if "$(TARGET_CPU)"=="i386"
	$(RELDIR_CPU)\fp10.obj \
!endif
	$(RELDIR_CPU)\loosefpmath.obj \
	$(RELDIR_CPU)\invalidcontinue.obj \
	$(RELDIR_CPU)\pinvalidcontinue.obj \
	$(RELDIR_CPU)\nochkclr.obj \
	$(RELDIR_CPU)\binmode.obj  \
	$(RELDIR_CPU)\pbinmode.obj  \
	$(RELDIR_CPU)\chkstk.obj   \
!if "$(TARGET_CPU)"=="i386"
	$(RELDIR_CPU)\alloca16.obj \
!endif
!if "$(TARGET_CPU)"=="AMD64"
	$(RELDIR_CPU)\chkstk2.obj   \
!endif
	$(RELDIR_CPU)\newmode.obj  \
	$(RELDIR_CPU)\pnewmode.obj  \
	$(RELDIR_CPU)\noarg.obj    \
	$(RELDIR_CPU)\pnoarg.obj    \
	$(RELDIR_CPU)\noenv.obj    \
	$(RELDIR_CPU)\pnoenv.obj    \
	$(RELDIR_CPU)\setargv.obj  \
	$(RELDIR_CPU)\psetargv.obj  \
	$(RELDIR_CPU)\smalheap.obj \
	$(RELDIR_CPU)\wsetargv.obj \
	$(RELDIR_CPU)\pwsetargv.obj \
	$(RELDIR_CPU)\commode.obj  \
	$(RELDIR_CPU)\pcommode.obj  \
	$(RELDIR_CPU)\nothrownew.obj \
	$(RELDIR_CPU)\pnothrownew.obj \
	$(RELDIR_CPU)\threadlocale.obj \
	$(RELDIR_CPU)\pthreadlocale.obj \
	$(RELDIR_CPU)\thrownew.obj \
!if "$(PRE_BLD)"!="1" && "$(BLD_OBJ)"!="1" && "$(BLD_SYSCRT)"!="1" && "$(PHASE)"!="BOOT" && "$(BLD_MSIL)"=="1"
!endif


!endif


$(RELDIR_CPU)\binmode.obj: $(OBJDIR_MT)\binmode.obj
	copy $** $@

$(RELDIR_CPU)\chkstk.obj: $(OBJDIR_MT)\chkstk.obj
	copy $** $@

$(RELDIR_CPU)\alloca16.obj: $(OBJDIR_MT)\alloca16.obj
	copy $** $@

$(RELDIR_CPU)\chkstk2.obj: $(OBJDIR_MT)\chkstk2.obj
	copy $** $@

$(RELDIR_CPU)\commode.obj: $(OBJDIR_MT)\commode.obj
	copy $** $@

$(RELDIR_CPU)\newmode.obj: $(OBJDIR_MT)\newmode.obj
	copy $** $@


$(RELDIR_CPU)\noarg.obj: $(OBJDIR_MT)\noarg.obj
	copy $** $@

$(RELDIR_CPU)\noenv.obj: $(OBJDIR_MT)\noenv.obj
	copy $** $@

$(RELDIR_CPU)\setargv.obj: $(OBJDIR_MT)\setargv.obj
	copy $** $@

$(RELDIR_CPU)\smalheap.obj: $(OBJDIR_MT)\smalheap.obj
	copy $** $@

$(RELDIR_CPU)\threadlocale.obj: $(OBJDIR_MT)\threadlocale.obj
	copy $** $@

$(RELDIR_CPU)\thrownew.obj: $(OBJDIR_MT)\thrownew.obj
	copy $** $@

$(RELDIR_CPU)\nothrownew.obj: $(OBJDIR_MT)\nothrownew.obj
	copy $** $@

$(RELDIR_CPU)\wsetargv.obj: $(OBJDIR_MT)\wsetargv.obj
	copy $** $@

$(RELDIR_CPU)\loosefpmath.obj: $(OBJDIR_MT)\loosefpmath.obj
	copy $** $@
	
$(RELDIR_CPU)\invalidcontinue.obj: $(OBJDIR_MT)\invalidcontinue.obj
	copy $** $@
		
$(RELDIR_CPU)\nochkclr.obj: $(OBJDIR_MT)\nochkclr.obj
	copy $** $@

!if "$(TARGET_CPU)"=="i386"
$(RELDIR_CPU)\fp10.obj: $(OBJDIR_MT)\fp10.obj
	copy $** $@
!endif


#<eof>
