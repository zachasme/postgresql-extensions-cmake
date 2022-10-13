#include <postgres.h> // Primary include file for PostgreSQL server .c files
#include <fmgr.h>     // PG_FUNCTION_INFO_V1
#include <funcapi.h>  // SRF_IS_FIRSTCALL

PG_MODULE_MAGIC;

PGDLLEXPORT PG_FUNCTION_INFO_V1(basic);
PGDLLEXPORT PG_FUNCTION_INFO_V1(my_set_returning_function);

Datum basic(PG_FUNCTION_ARGS) {
  int arg = PG_GETARG_INT32(0);

  elog(LOG, "basic called");

  PG_RETURN_INT32(arg);
}

Datum
my_set_returning_function(PG_FUNCTION_ARGS)
{
    FuncCallContext  *funcctx;
    Datum             result;

    if (SRF_IS_FIRSTCALL())
    {
        MemoryContext oldcontext;

        funcctx = SRF_FIRSTCALL_INIT();
        oldcontext = MemoryContextSwitchTo(funcctx->multi_call_memory_ctx);
        /* One-time setup code appears here: */
        MemoryContextSwitchTo(oldcontext);
    }

    /* Each-time setup code appears here: */
    funcctx = SRF_PERCALL_SETUP();

    /* this is just one way we might test whether we are done: */
    if (funcctx->call_cntr < funcctx->max_calls)
    {
        /* Here we want to return another item: */
        SRF_RETURN_NEXT(funcctx, result);
    }
    else
    {
        /* Here we are done returning items, so just report that fact. */
        /* (Resist the temptation to put cleanup code here.) */
        SRF_RETURN_DONE(funcctx);
    }
}
