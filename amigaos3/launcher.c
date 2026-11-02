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

    /* Start windowed until the full-screen retained-surface path is qualified.
     * The in-game F key still toggles full-screen. */
    result = SystemTags((CONST_STRPTR)"Barrage -w", TAG_DONE);

    if (launch_dir != 0) {
        CurrentDir(old_dir);
        UnLock(launch_dir);
    }

    return result == -1 ? RETURN_FAIL : RETURN_OK;
}
