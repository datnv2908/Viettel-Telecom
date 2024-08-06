/*
 * Copyright (c) 2017 Verimatrix, Inc.  All Rights Reserved.
 * The Software or any portion thereof may not be reproduced in any form
 * whatsoever except as provided by license, without the written consent of
 * Verimatrix.
 *
 * THIS NOTICE MAY NOT BE REMOVED FROM THE SOFTWARE BY ANY USER THEREOF.
 * NEITHER VERIMATRIX NOR ANY PERSON OR ORGANIZATION ACTING ON BEHALF OF
 * THEM:
 *
 * 1. MAKES ANY WARRANTY OR REPRESENTATION WHATSOEVER, EXPRESS OR IMPLIED,
 *    INCLUDING ANY WARRANTY OF MERCHANTABILITY OR FITNESS FOR ANY
 *    PARTICULAR PURPOSE WITH RESPECT TO THE SOFTWARE;
 *
 * 2. ASSUMES ANY LIABILITY WHATSOEVER WITH RESPECT TO ANY USE OF THE
 *    PROGRAM OR ANY PORTION THEREOF OR WITH RESPECT TO ANY DAMAGES WHICH
 *     MAY RESULT FROM SUCH USE.
 *
 * RESTRICTED RIGHTS LEGEND:  Use, duplication or disclosure by the
 * Government is subject to restrictions set forth in subparagraphs
 * (a) through (d) of the Commercial Computer Software-Restricted Rights
 * at FAR 52.227-19 when applicable, or in subparagraph (c)(1)(ii) of the
 * Rights in Technical Data and Computer Software clause at
 * DFARS 252.227-7013, and in similar clauses in the NASA FAR supplement,
 * as applicable. Manufacturer is Verimatrix, Inc.
 */
#ifndef VIEWRIGHTWEBIOS_H
#define VIEWRIGHTWEBIOS_H

#include <Foundation/Foundation.h>
#include <string>
#include <vector>

using namespace std;

@class ViewRightSecurity;
class ViewRightWebiOSCallbacks;

@protocol VRSecurityCallback
- (void)securityCallback; // Called when a security error is encountered - player should terminate playback

struct OutputControls
{
    bool    BestEffort_Enabled; // Use best efforts on each setting, but not mandatory
    int     ccACP_Level; // 0=off, 1, 2, 3
    bool    DwightCavendish_Enabled;
    bool	HDCP_Enabled; // ON = use highest verison available
    int     ccCGMS_A_Level; // 0=Freely, No More, Once, Never
    bool    CIT_Analog_Enabled; // HD must be downres on Analog output
    bool    CIT_Digital_Enabled; // HD must be downres if no HDCP
    bool    DOT_Enabled; // Doesn't allow playback on Analog
    bool    Anti_Mirroring_Enabled; // Disable mirroring (e.g. Airplay on iOS)
};

- (void) ConfigureOutputControlSettings:(struct OutputControls) settings; // it is up to the player to implement the handling of output controls

struct OperatorDataStruct
{
    bool bGlobal; // true if the data is Global Operator Data
    char data[257]; //256 max plus a char for \0
    unsigned int dataSize;
};

- (void) OperatorData:(struct OperatorDataStruct) data;
@end

@class AVAssetResourceLoader;
@class AVAssetResourceLoadingRequest;

class ViewRightWebiOS
{
    public:
        enum VRWebiOSError_t
        {
            Success = 0,
            NoConnect = 1,
            GeneralError = 2,
            BadMemoryAlloc = 3,
            BadRandNumGen = 4,
            BadURL = 5,
            BadReply = 6,
            BadReplyMoved = 7,
            BadVerifyCertificateChain = 8,
            BadCreateKeyPair = 9,
            NotEntitled = 10,
            BadCreateStore = 11,
            BadWriteStore = 12,
            BadReadStore = 13,
            BadStoreIntegrity = 14,
            BadStoreFileNoExist = 15,
            BadCert = 16,
            BadINI = 17,
            BadPrivateKey = 18,
            BadConvertPEMToX509 = 19,
            BadPublicEncrypt = 20,
            BadAddX509Entry = 21,
            BadAddX509Subject = 22,
            BadX509Sign = 23,
            CantRetrieveBoot = 24,
            CantProvision = 25,
            BadArguments = 26,
            BadKeyGeneration = 27,
            NotProvisioned = 28,
            CommunicationObjectNotInitialized = 29,
            NoOTTSignature = 30,
            BadOTTSignature = 31,
            KeyFileNotEntitled = 32,
            CertificateExpired = 33,
            IntegrityCheckFailed = 34,
            SecurityError = 35,
            FeatureUnavailable = 36,
            NoUniqueIdentifier = 37,
            HandshakeError = 38,
            FailedKeyURLParse = 39,
            UnsupportedAssetType = 40,//this error will not be returned at all, as offline support is added for DTV streams
            OfflineNotAllowed = 41,
            FailedNoKeysAvailableOffline = 42,
            VR_OfflineMode = 43,
            InvalidCertificateRequest = 44,
            BadHash = 45,
            FailedStoreMove = 46,
            GlobalPolicySecurityError = 47,
            AssetPolicySecurityError = 48,
            DashInfoUnavailable = 49,
            BadState = 50,
            FailedCommonResourcesInit = 51,
            DeviceRevoked = 52,
            NoKeyHandler = 53,
            FailedToSetViid = 54,
            NeedReprovision = 55,
            DeprecatedAPI = 56,
            FailedToSetSiteKey = 57,
            NoVMInfoInAMM = 58,
            EmulatorDetected = 59,
            NonFMP4 = 60,
            Mp4BrandNotSupported = 61,
            Mp4EncodingNotSupported = 62,
            Mp4EncSchemNotSupported = 63,
            Mp4PSSHBoxNotFound = 64,
            MP4VmxKeyURLNotPresent = 65,
            RecordingON = 66,
            ContentNotFound = 67,
            LAST_ERROR_CODE
        };

        enum LogLevel_t
        {
            LogOff = 0,
            LogError,
            LogInfo,
            LogDebug,
            LogTrace
        };

        enum MethodInfo
        {
            NONE = 0,
            AES_128_CBC,
            SAMPLE_AES,
            AES_128_CTR,
            FMP4
        };

        enum StreamingFormat
        {
            HLS_TS = 0,
            HLS_FMP4,
            DASH
        };

        bool GetUniqueIdentifier( char ** uniqueID, int * length );
        VRWebiOSError_t SetVdisPrefix(const char * vdisPrefix);

        const char * GetVersion();

        static ViewRightWebiOS * Instance();
    
        static void ResetInstance();

        VRWebiOSError_t SetupProvisioning( const char * bootHost, const char * path, const char * companyName = "", bool bThirdPartyMode = false );
        VRWebiOSError_t ProvisionDevice();
        VRWebiOSError_t IsDeviceProvisioned();

        bool Initialize( void );
        bool Open( const char * inURL, char ** outURL );
        bool Close( );
        bool isScreenRecordingDetected();

        //HLS Decrypt
        VRWebiOSError_t Decrypt(unsigned char * data, unsigned long & dataSize, MethodInfo decryptMethod, const char * keyfileURL, const unsigned char * keyIV, unsigned int keyIVSize = 16, StreamingFormat format = StreamingFormat::HLS_TS);

        // Add this to the AVPlayer's AVAssetResourceLoaderDelegate's shouldWaitForLoadingOfRequestedResource method
        VRWebiOSError_t FPSKeyResourceLoader(AVAssetResourceLoadingRequest * loadingRequest, BOOL isFPSOfflineEnabled=false);
    
        VRWebiOSError_t ResetStream(unsigned int engineId);

        VRWebiOSError_t SetAMMTimeout(unsigned int timeInMinute);
        VRWebiOSError_t RetrieveAMM(const char * resourceId);
        void EnableLog( LogLevel_t logLevel );

        unsigned long long GetCertificateExpirationTime(void);

        void SetSecurityCallbackDelegate(id<VRSecurityCallback> securityCallbackDelegate);

        VRWebiOSError_t MoveStore(NSString * directoryName, const char * host, const char * path, const char * companyName);

        //Last error code

        VRWebiOSError_t GetLastErrorCode();

        //offline

        void GetStoredAssetIds(vector<char *> & assets);

        unsigned long RemainingKeyExpiration(const char * assetId);

        bool DeleteAllKeys(const char * assetId);

        VRWebiOSError_t StoreOfflineKey(const char * keyFileURL);

        void SetOfflineMode(bool isOfflineMode);

        void SetStoreOfflineKeyEnabled(bool onOff);

        VRWebiOSError_t VerifyHandshake(unsigned char * bufferEncIn, int  bufferEncLengthIn);
        VRWebiOSError_t IsHandshakeVerified();

    
    protected:
        ViewRightWebiOS();
        ~ViewRightWebiOS();

    private:
        void InitializeValues(const char * host, const char * path, const char * companyName);
        ViewRightWebiOS::VRWebiOSError_t ReadFromPersistentStorage(NSString * keySaveLocation,AVAssetResourceLoadingRequest * loadingRequest,NSData* persistentContentKeyDataOffline,string resourceID,unsigned long remKey);
        static ViewRightWebiOS *        m_instance;
        static const char *             m_version;
        ViewRightSecurity *             m_pSecurity;
        bool                            m_bThirdPartyPlayer;
        bool                            m_bisStoreEnabled;

        id<VRSecurityCallback>          m_SecurityCallbackDelegate;
        ViewRightWebiOSCallbacks *      m_pCallbacks;

        char *                          m_pStorePath;
        char *                          m_host;
        char *                          m_companyName;
        LogLevel_t                      m_LogLevel;
        bool                            m_bFPSOfflineMode;
        bool                            m_bisLogEnabled;
};

#endif  /*  VIEWRIGHTWEBIOS_H */
