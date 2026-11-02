#include <dos/dos.h>
#include <dos/dostags.h>
#include <proto/dos.h>

/* Native Workbench launcher: no IconX, Execute or shell script required. */
int main(void)
{
    BPTR program_dir = GetProgramDir();
    BPTR old_dir = 0;
    BPTR launch_dir = 0;
    LONG result;

    if (program_dir != 0)
        launch_dir = DupLock(program_dir);
    if (launch_dir != 0)
        old_dir = CurrentDir(launch_dir);

    result = SystemTags((CONST_STRPTR)"Barrage", TAG_DONE);

    if (launch_dir != 0) {
        CurrentDir(old_dir);
        UnLock(launch_dir);
    }

    return result == -1 ? RETURN_FAIL : RETURN_OK;
}
