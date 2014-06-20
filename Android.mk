## kevin@xmic: modify_ntfs-3g-for-bionic_c
## Android.mk for ntfs-3g as an external module for android.

LOCAL_PATH := $(call my-dir)

###################################################################
## For stage 1, we have to make  libfuse
###################################################################
include $(CLEAR_VARS)

LOCAL_SRC_FILES :=  \
    ic_util/ic_util.c \
    libfuse-lite/fuse.c libfuse-lite/fusermount.c libfuse-lite/fuse_kern_chan.c libfuse-lite/fuse_loop.c\
    libfuse-lite/fuse_lowlevel.c libfuse-lite/fuse_opt.c libfuse-lite/fuse_session.c libfuse-lite/fuse_signals.c\
    libfuse-lite/helper.c libfuse-lite/mount.c libfuse-lite/mount_util.c 

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include/fuse-lite  $(LOCAL_PATH)/include/ic_util

LOCAL_CFLAGS := -O2 -g -W -Wall -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -DHAVE_CONFIG_H

LOCAL_MODULE := libfuse_static
LOCAL_MODULE_TAGS := optional
LOCAL_SYSTEM_SHARED_LIBRARIES := libc libcutils 

include $(BUILD_STATIC_LIBRARY)

###################################################################
## For stage 2, we have to make  libntfs-3g
###################################################################
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    ic_util/ic_util.c \
    libntfs-3g/acls.c  libntfs-3g/attrib.c libntfs-3g/attrlist.c libntfs-3g/bitmap.c\
    libntfs-3g/bootsect.c libntfs-3g/cache.c libntfs-3g/collate.c libntfs-3g/compat.c libntfs-3g/compress.c \
    libntfs-3g/debug.c libntfs-3g/device.c libntfs-3g/dir.c libntfs-3g/efs.c libntfs-3g/index.c libntfs-3g/inode.c\
    libntfs-3g/lcnalloc.c libntfs-3g/logfile.c libntfs-3g/logging.c libntfs-3g/mft.c libntfs-3g/misc.c libntfs-3g/mst.c\
    libntfs-3g/object_id.c libntfs-3g/realpath.c libntfs-3g/reparse.c libntfs-3g/runlist.c libntfs-3g/security.c libntfs-3g/unistr.c\
    libntfs-3g/unix_io.c libntfs-3g/volume.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include/fuse-lite  $(LOCAL_PATH)/include/ntfs-3g  $(LOCAL_PATH)/include/ic_util

LOCAL_CFLAGS := -O2 -g -W -Wall -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -DHAVE_CONFIG_H

LOCAL_MODULE := libntfs-3g_static
LOCAL_MODULE_TAGS := optional
LOCAL_SYSTEM_SHARED_LIBRARIES := libc libcutils 

include $(BUILD_STATIC_LIBRARY)


###################################################################
## For stage 3, we make ntfs-3g
###################################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES := src/ntfs-3g_common.c src/ntfs-3g.c  

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include/fuse-lite  $(LOCAL_PATH)/include/ntfs-3g \
    $(LOCAL_PATH)/src  $(LOCAL_PATH)/include/ic_util

LOCAL_CFLAGS := -O2 -g -W -Wall -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -DHAVE_CONFIG_H

LOCAL_MODULE := ntfs-3g

LOCAL_MODULE_TAGS := optional
LOCAL_SYSTEM_SHARED_LIBRARIES := libc libcutils
LOCAL_STATIC_LIBRARIES := libfuse_static libntfs-3g_static

include $(BUILD_EXECUTABLE)


###################################################################
## For stage 4, we make ntfs-3g.probe
###################################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES := src/ntfs-3g.probe.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include/fuse-lite  $(LOCAL_PATH)/include/ntfs-3g  $(LOCAL_PATH)/include/ic_util \
    $(LOCAL_PATH)/src

LOCAL_CFLAGS := -O2 -g -W -Wall -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -DHAVE_CONFIG_H

LOCAL_MODULE := ntfs-3g.probe

LOCAL_MODULE_TAGS := optional
LOCAL_SYSTEM_SHARED_LIBRARIES := libc libcutils
LOCAL_STATIC_LIBRARIES := libfuse_static libntfs-3g_static

include $(BUILD_EXECUTABLE)


###################################################################
## For stage 5, we make ntfslabel
###################################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES := ntfsprogs/utils.c ntfsprogs/ntfslabel.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include/fuse-lite  $(LOCAL_PATH)/include/ntfs-3g  $(LOCAL_PATH)/include/ic_util \
    $(LOCAL_PATH)/ntfsprogs

LOCAL_CFLAGS := -O2 -g -W -Wall -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -DHAVE_CONFIG_H

LOCAL_MODULE := ntfslabel

LOCAL_MODULE_TAGS := optional
LOCAL_SYSTEM_SHARED_LIBRARIES := libc libcutils
LOCAL_STATIC_LIBRARIES := libfuse_static libntfs-3g_static

include $(BUILD_EXECUTABLE)
