//<< kevin@xmic: modify_ntfs-3g-for-bionic_c
/* kevin@xmic
 *      define interface libfuse/libntfs-3g need but bionic c didn't provide.
 */

#include <sys/types.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <mntent.h>

#include "ic_util.h"


//<< kevin@xmic: modify_ntfs-3g-for-bionic_c
struct mntent *getmntent_r (FILE *filep,
    struct mntent *mnt, char *buff, int bufsize)
{
    static const char sep[] = " \t\n";

    char *cp, *ptrptr;

    if (!filep || !mnt || !buff)
        return NULL;

    /* Loop on the file, skipping comment lines. - FvK 03/07/93 */
    while ((cp = fgets(buff, bufsize, filep)) != NULL) {
        if (buff[0] == '#' || buff[0] == '\n')
            continue;
        break;
    }

    /* At the EOF, the buffer should be unchanged. We should
     * check the return value from fgets ().
     */
    if (cp == NULL)
        return NULL;

    ptrptr = 0;
    mnt->mnt_fsname = strtok_r(buff, sep, &ptrptr);
    if (mnt->mnt_fsname == NULL)
        return NULL;

    mnt->mnt_dir = strtok_r(NULL, sep, &ptrptr);
    if (mnt->mnt_dir == NULL)
        return NULL;

    mnt->mnt_type = strtok_r(NULL, sep, &ptrptr);
    if (mnt->mnt_type == NULL)
        return NULL;

    mnt->mnt_opts = strtok_r(NULL, sep, &ptrptr);
    if (mnt->mnt_opts == NULL)
        mnt->mnt_opts = "";

    cp = strtok_r(NULL, sep, &ptrptr);
    mnt->mnt_freq = (cp != NULL) ? atoi(cp) : 0;

    cp = strtok_r(NULL, sep, &ptrptr);
    mnt->mnt_passno = (cp != NULL) ? atoi(cp) : 0;

    return mnt;
}


struct mntent *getmntent(FILE * filep)
{
    struct mntent *tmp;
    static char *buff = NULL;
    static struct mntent mnt;
//    __UCLIBC_MUTEX_LOCK(mylock);

    if (!buff) {
            buff = malloc(BUFSIZ);
        if (!buff)
            abort();
    }

    tmp = getmntent_r(filep, &mnt, buff, BUFSIZ);
//    __UCLIBC_MUTEX_UNLOCK(mylock);
    return(tmp);
}

int addmntent(FILE * filep, const struct mntent *mnt)
{
    if (fseek(filep, 0, SEEK_END) < 0)
        return 1;

    return (fprintf (filep, "%s %s %s %s %d %d\n", mnt->mnt_fsname, mnt->mnt_dir,
         mnt->mnt_type, mnt->mnt_opts, mnt->mnt_freq, mnt->mnt_passno) < 0 ? 1 : 0);
}

char *hasmntopt(const struct mntent *mnt, const char *opt)
{
    return strstr(mnt->mnt_opts, opt);
}

FILE *setmntent(const char *name, const char *mode)
{
    return fopen(name, mode);
}

int endmntent(FILE * filep)
{
    if (filep != NULL)
        fclose(filep);
    return 1;
}
//>> kevin@xmic: modify_ntfs-3g-for-bionic_c
