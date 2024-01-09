bool isDebugMode = true;

void printDebugLog(String debugLog) {
  if (isDebugMode) {
    print(debugLog);
  }
}
