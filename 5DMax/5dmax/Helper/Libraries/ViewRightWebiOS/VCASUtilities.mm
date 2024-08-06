//
//  VCASUtilities.m
//  PlayVcas
//
//  Created by Matthew Fite on 6/30/10.
//  Copyright 2010 Verimatrix. All rights reserved.
//

#import "VCASUtilities.h"
#import "AppConstants.h"
#import <ViewRightWebiOS/ViewRightWebiOS.h>
#import <Security/Security.h>

@implementation VCASUtilities

+ (void)initialize {
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"27.67.49.248", HOST_ADDRESS_SETTING,
                                 [NSNumber numberWithInt:80], PORT_NUMBER_SETTING,
                                 @"Viettel", COMPANY_NAME_SETTING,
                                 [NSNumber numberWithBool:NO], REPROVISION_SETTING,
                                 [NSNumber numberWithBool:YES], LOGGING_SETTING,
                                 nil];
	
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs registerDefaults:appDefaults];
}

+ (NSString *) writablePath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *) storeFile {
    // TODO
    // i'm not sure if i'm handling memory allocation the "apple" way
    // since i'm allocating the memory here, and then relying on the
    // user to call release.  it seems the model is supposed to be
    // the user calls alloc/initWith... and then calls release.
    NSString * pathWithPathComponent = [NSString stringWithFormat:@"%@",[[[VCASUtilities writablePath]
                                                                          stringByAppendingString:@"/"]
                                                                         stringByAppendingString:STORE_FILE_NAME]];

    
    NSLog(@"path with path component %@", pathWithPathComponent);
    return pathWithPathComponent;
}

+ (NSString *) moviePlist {
    NSString * pathWithPathComponent = [NSString stringWithFormat:@"%@",[[[VCASUtilities writablePath]
                                                                          stringByAppendingString:@"/"]
                                                                         stringByAppendingString:MOVIE_PLIST_NAME]];
    
    
    NSLog(@"path with path component %@", pathWithPathComponent);
    return pathWithPathComponent;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key
{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx    = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

+ (BOOL) CreateHandshake:(uint8_t **)cipherText :(unsigned int *)cipherTextLen
{
    NSString *key = @"-----BEGIN PUBLIC KEY-----\n"
    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8+W+dagQRKLpVhBCWWtk\n"
    "gnds/2sheAfbMLaQOwhSTg6pQOdqdfrXg1+v7+9DvWqhI2BqePk3DIqPfiozWJM4\n"
    "8A+g/1CxPLqKBA8VkGB33zOHyP0CZVDOL34QRyhGc0JmORDWTD/Cy56XUEtuYrj0\n"
    "6MOm4EhqhEdekv72eDnuOle9akZMesLZFYoiPRS0Mouio4REHzxTIKiIvnv/t90d\n"
    "fPh5tuPDORJxuFpKnl9ux+7j14b2g6iMw3/o1pxDTXISpGn1GjtaRQJaMJPBMBCT\n"
    "/aKyNrwy+oUnaIL+DoZLK9PCS0lMVREynUTdR03Bvr2fM2FqAKkbM4NXmTu0U9eG\n"
    "fwIDAQAB\n"
    "-----END PUBLIC KEY-----\n";

    NSString *s_key = [NSString string];
    NSArray  *a_key = [key componentsSeparatedByString:@"\n"];
    BOOL     f_key  = FALSE;
    
    for (NSString *a_line in a_key)
    {
        if ([a_line isEqualToString:@"-----BEGIN PUBLIC KEY-----"])
        {
            f_key = TRUE;
        }
        else if ([a_line isEqualToString:@"-----END PUBLIC KEY-----"])
        {
            f_key = FALSE;
        }
        else if (f_key)
        {
            s_key = [s_key stringByAppendingString:a_line];
        }
    }

    // NSLog(@"Key length = %lu",(unsigned long)s_key.length);
    if (s_key.length == 0) return FALSE;
    
    // This will be base64 encoded, decode it.
    NSData *d_key = [[NSData alloc] initWithBase64EncodedString:s_key options:0];
    d_key = [self stripPublicKeyHeader:d_key];
    if (d_key == nil) return FALSE;

    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(id) kSecClassKey forKey:(id)kSecClass];
    [publicKey setObject:(id) kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];

    SecItemDelete((CFDictionaryRef)publicKey);
    
    CFTypeRef persistKey = nil;
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:d_key forKey:(id)kSecValueData];
    [publicKey setObject:(id) kSecAttrKeyClassPublic forKey:(id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(id)
     kSecReturnPersistentRef];
    
    OSStatus secStatus = SecItemAdd((CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil) CFRelease(persistKey);
    
    if ((secStatus != noErr) && (secStatus != errSecDuplicateItem))
    {
        return(FALSE);
    }

    SecKeyRef keyRef = nil;
    
    [publicKey removeObjectForKey:(id)kSecValueData];
    [publicKey removeObjectForKey:(id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnRef
     ];
    [publicKey setObject:(id) kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
    secStatus = SecItemCopyMatching((CFDictionaryRef)publicKey,
                                    (CFTypeRef *)&keyRef);
    
    
    if (keyRef == nil)
    {
        NSLog(@"No RSA public key");
        return FALSE;
    }

    size_t cipherBufferLen = SecKeyGetBlockSize(keyRef);
    uint8_t *cipherBuffer = new unsigned char[cipherBufferLen];
    
    const char * handshake_string = "MNDdsasd39450213fdfdfmasduiteer245762312we35";
    
    char handshakePidString[256] = "";
    
    unsigned int pid = (unsigned int) getpid();
    snprintf(handshakePidString, 255, "%s%d", handshake_string, pid);

    
    SecKeyEncrypt(keyRef,
                  kSecPaddingOAEP,
                  (uint8_t *) handshakePidString,
                  strlen(handshakePidString),
                  cipherBuffer,
                  &cipherBufferLen);

    *cipherText = cipherBuffer;
    *cipherTextLen = cipherBufferLen;

    return TRUE;
}

+ (ViewRightWebiOS::VRWebiOSError_t) provisionDevice
{
    ViewRightWebiOS::VRWebiOSError_t err = ViewRightWebiOS::Success;
    
    NSUserDefaults * vcasDefaults = [NSUserDefaults standardUserDefaults];
    NSString * hostString = [vcasDefaults stringForKey:HOST_ADDRESS_SETTING];
    NSString * portString = [vcasDefaults stringForKey:PORT_NUMBER_SETTING];
    NSString * companyName = [vcasDefaults stringForKey:COMPANY_NAME_SETTING];
    NSString * bootString = [[hostString stringByAppendingString:@":"] stringByAppendingString:portString];
    
    NSString * storePath = [VCASUtilities writablePath];
    
    const char * docString = [storePath UTF8String];

    bool forceReprovision = [[NSUserDefaults standardUserDefaults] boolForKey:REPROVISION_SETTING];
    if ( forceReprovision ) {
        NSString * storeFile = [VCASUtilities storeFile];
        NSLog(@"deleting %@", storeFile);
        if ([[NSFileManager defaultManager] removeItemAtPath:storeFile error:nil]) {
            NSLog(@"deleted store file");
        }
    }
    
    // unset force reprovision setting
    [vcasDefaults setBool:NO forKey:REPROVISION_SETTING];
    
    // if logging is enabled in the settings, then enable it
    bool enableLogging = [[NSUserDefaults standardUserDefaults] boolForKey:LOGGING_SETTING];
    if (enableLogging) {
        ViewRightWebiOS::Instance()->EnableLog( (ViewRightWebiOS::LogLevel_t)LOG_LEVEL );
    }
    
    unsigned char * EncryptedHandshake = NULL;
    unsigned int EncryptedHandshakeLen = 0;
    
    [self CreateHandshake:&EncryptedHandshake :&EncryptedHandshakeLen];
    
    if(EncryptedHandshake && EncryptedHandshakeLen)
    {
        err = ViewRightWebiOS::Instance()->VerifyHandshake(EncryptedHandshake, EncryptedHandshakeLen);
        if(err != ViewRightWebiOS::Success)
        {
            delete[] EncryptedHandshake;
            NSLog(@"VerifyHandshake failed - %d", err);
            return err;
        }
        
        delete[] EncryptedHandshake;
    }
    else
    {
        NSLog(@"VerifyHandshake failed - EncryptedHandshake: %p, EncryptedHandshakeLen: %d", EncryptedHandshake, EncryptedHandshakeLen);
        return ViewRightWebiOS::VRWebiOSError_t::HandshakeError;
    }
    
    err = ViewRightWebiOS::Instance()->IsHandshakeVerified();
    if(err != ViewRightWebiOS::Success)
    {
        return err;
    }

    err = ViewRightWebiOS::Instance()->SetupProvisioning([bootString cStringUsingEncoding:NSASCIIStringEncoding], docString, [companyName cStringUsingEncoding:NSASCIIStringEncoding]);
    
	if(err != ViewRightWebiOS::Success)
        return err;
    
	err = ViewRightWebiOS::Instance()->IsDeviceProvisioned();
    
	if(err != ViewRightWebiOS::VR_OfflineMode && err != ViewRightWebiOS::Success)
		err = ViewRightWebiOS::Instance()->ProvisionDevice();
	
    return err;
}

+ (ViewRightWebiOS::VRWebiOSError_t)MoveStore:(NSString *) directoryName
{
    NSUserDefaults * vcasDefaults = [NSUserDefaults standardUserDefaults];
    NSString * hostString = [vcasDefaults stringForKey:HOST_ADDRESS_SETTING];
    NSString * portString = [vcasDefaults stringForKey:PORT_NUMBER_SETTING];
    NSString * companyName = [vcasDefaults stringForKey:COMPANY_NAME_SETTING];
    
    return ViewRightWebiOS::Instance()->MoveStore(directoryName, [[[hostString stringByAppendingString:@":"] stringByAppendingString:portString] cStringUsingEncoding:NSASCIIStringEncoding], [[VCASUtilities writablePath] UTF8String], [companyName cStringUsingEncoding:NSASCIIStringEncoding]);
}

+ (void)forceProvisionDevice {
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    [myDefaults setBool:YES forKey:REPROVISION_SETTING];
    [myDefaults synchronize];
    [VCASUtilities provisionDevice];
}

+ (NSString *) getDeviceIdentifier {
    NSUserDefaults * vcasDefaults = [NSUserDefaults standardUserDefaults];
    int length;
    char * temp;
    NSString *deviceIdentifier = [vcasDefaults stringForKey:DEVICE_IDENTIFIER];
    if (deviceIdentifier == nil || [deviceIdentifier isEqualToString:@"unknown"]) {
        bool err = ViewRightWebiOS::Instance()->GetUniqueIdentifier( &temp, &length );
        if (err == false)
        {
            deviceIdentifier = @"unknown";
        }
        else
        {
            deviceIdentifier = [[NSString alloc] initWithUTF8String:temp];
            free( temp );
        }
        [vcasDefaults setObject:deviceIdentifier forKey:DEVICE_IDENTIFIER];
        [vcasDefaults synchronize];
        return deviceIdentifier;
    } else {
        return  deviceIdentifier;
    }
}

@end
