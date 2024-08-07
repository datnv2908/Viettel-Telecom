import { ExecutionResult } from '@apollo/react-common';
import { useCallback } from 'react';
import { useToasts } from 'react-toast-notifications';

import { useLoginContext } from '../containers/Login';
import { Payload } from '../queries';

const REQUIRE_LOGIN = '000002';

export function useResponseHandler<T>(
  mutationResultExtractor: (
    res: ExecutionResult<T>
  ) => (Payload & { result?: unknown }) | undefined,
  successMessage?: string
) {
  const { addToast } = useToasts();
  const { showLogin } = useLoginContext();
  return useCallback(
    (res: ExecutionResult<T>) => {
      const result = mutationResultExtractor(res);
      switch (result?.errorCode) {
        case REQUIRE_LOGIN:
          showLogin?.();
          break;

        default:
          const message = (typeof result?.result === 'string' && result.result) || result?.message;
          if (message !== 'Successful' || successMessage) {
            addToast(result?.success ? successMessage || message : message, {
              appearance: result?.success ? 'success' : 'error',
              autoDismiss: true,
            });
          }
      }
      return res;
    },
    [addToast, mutationResultExtractor, showLogin, successMessage]
  );
}
