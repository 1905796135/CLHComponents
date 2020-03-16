//
//  NSString+RSA.m
//  PBKit
//
//  Created by Jerry on 2017/5/23.
//  Copyright © 2017年 core. All rights reserved.
//

#import "NSString+RSA.h"
#import "CoreMacros.h"

@implementation NSString (RSA)

- (NSString *)encryptByRSAPrivateKey:(NSString *)privateKey {
    NSData *data = encryptDataByRSAPrivateKey([self dataUsingEncoding:NSUTF8StringEncoding], privateKey);
    return base64EncodeData(data);
}

- (NSString *)encryptByRSAPublicKey:(NSString *)publicKey {
    NSData *data = encryptDataByRSAPublicKey([self dataUsingEncoding:NSUTF8StringEncoding], publicKey);
    return base64EncodeData(data);
}

- (NSString *)decryptByRSAPrivateKey:(NSString *)privateKey {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = decryptDataByRSAPrivateKey(data, privateKey);
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


- (NSString *)decryptByRSAPublicKey:(NSString *)publicKey {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = decryptDataByRSAPublicKey(data, publicKey);
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - Utility

static NSData *encryptDataByRSAPrivateKey(NSData *data, NSString *privateKey) {
    if (!data || !privateKey) {
        return nil;
    }
    SecKeyRef keyRef = addPrivateKey(privateKey);
    if (!keyRef) {
        return nil;
    }
    return encryptDataWithKeyRef(data, keyRef, true);
}

static NSData *encryptDataByRSAPublicKey(NSData *data, NSString *publicKey) {
    if (!data || !publicKey) {
        return nil;
    }
    SecKeyRef keyRef = addPublicKey(publicKey);
    if (!keyRef) {
        return nil;
    }
    return encryptDataWithKeyRef(data, keyRef, false);
}

static NSData *decryptDataByRSAPrivateKey(NSData *data, NSString *privateKey) {
    if (!data || !privateKey) {
        return nil;
    }
    SecKeyRef keyRef = addPrivateKey(privateKey);
    if (!keyRef) {
        return nil;
    }
    return decryptDataWithKeyRef(data, keyRef);
}

static NSData *decryptDataByRSAPublicKey(NSData *data, NSString *publicKey) {
    if (!data || !publicKey) {
        return nil;
    }
    SecKeyRef keyRef = addPublicKey(publicKey);
    if (!keyRef) {
        return nil;
    }
    return decryptDataWithKeyRef(data, keyRef);
}

static NSString *base64EncodeData(NSData *data) {
    data = [data base64EncodedDataWithOptions:0];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

static NSData *base64Decode(NSString *str) {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

static SecKeyRef addPrivateKey(NSString *key) {
    NSRange spos;
    NSRange epos;
    spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    if (spos.length > 0) {
        epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    } else {
        spos = [key rangeOfString:@"-----BEGIN PRIVATE KEY-----"];
        epos = [key rangeOfString:@"-----END PRIVATE KEY-----"];
    }

    if (spos.location != NSNotFound && epos.location != NSNotFound) {
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e - s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSData *data = base64Decode(key);
    data = stripPrivateKeyHeader(data);
    if (!data) {
        return nil;
    }

    NSString *tag = @"RSAUtil_PrivKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];

    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id) kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id) kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id) kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef) privateKey);

    [privateKey setObject:data forKey:(__bridge id) kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
            kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
            kSecReturnPersistentRef];

    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef) privateKey, &persistKey);
    if (persistKey != nil) {
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }

    [privateKey removeObjectForKey:(__bridge id) kSecValueData];
    [privateKey removeObjectForKey:(__bridge id) kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id) kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id) kSecAttrKeyType];

    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef) privateKey, (CFTypeRef *) &keyRef);
    if (status != noErr) {
        return nil;
    }
    return keyRef;
}

static SecKeyRef addPublicKey(NSString *key) {
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if (spos.location != NSNotFound && epos.location != NSNotFound) {
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e - s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSData *data = base64Decode(key);
    data = stripPublicKeyHeader(data);
    if (!data) {
        return nil;
    }

    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];

    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id) kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id) kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id) kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef) publicKey);

    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id) kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
            kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
            kSecReturnPersistentRef];

    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef) publicKey, &persistKey);
    if (persistKey != nil) {
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }

    [publicKey removeObjectForKey:(__bridge id) kSecValueData];
    [publicKey removeObjectForKey:(__bridge id) kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id) kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id) kSecAttrKeyType];

    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef) publicKey, (CFTypeRef *) &keyRef);
    if (status != noErr) {
        return nil;
    }
    return keyRef;
}

static NSData *stripPrivateKeyHeader(NSData *d_key) {
    // Skip ASN.1 private key header
    if (d_key == nil) return (nil);

    unsigned long len = [d_key length];
    if (!len) return (nil);

    unsigned char *c_key = (unsigned char *) [d_key bytes];
    unsigned int idx = 22; //magic byte at offset 22

    if (0x04 != c_key[idx++]) return nil;

    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

static NSData *stripPublicKeyHeader(NSData *d_key) {
    if (d_key == nil) return (nil);

    unsigned long len = [d_key length];
    if (!len) return (nil);

    unsigned char *c_key = (unsigned char *) [d_key bytes];
    unsigned int idx = 0;

    if (c_key[idx++] != 0x30) return (nil);

    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;

    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
            {0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
                    0x01, 0x05, 0x00};
    if (memcmp(&c_key[idx], seqiod, 15)) return (nil);

    idx += 15;

    if (c_key[idx++] != 0x03) return (nil);

    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;

    if (c_key[idx++] != '\0') return (nil);

    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

static NSData *decryptDataWithKeyRef(NSData *data, SecKeyRef keyRef) {
    const uint8_t *srcbuf = (const uint8_t *) [data bytes];
    size_t srclen = (size_t) data.length;

    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;

    NSMutableData *ret = [[NSMutableData alloc] init];
    for (int idx = 0; idx < srclen; idx += src_block_size) {
        size_t data_len = srclen - idx;
        if (data_len > src_block_size) {
            data_len = src_block_size;
        }

        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                kSecPaddingNone,
                srcbuf + idx,
                data_len,
                outbuf,
                &outlen
        );
        if (status != 0) {
            PBLog(@"SecKeyEncrypt fail. Error Code: %d", (int) status);
            ret = nil;
            break;
        } else {
            int idxFirstZero = -1;
            int idxNextZero = (int) outlen;
            for (int i = 0; i < outlen; i++) {
                if (outbuf[i] == 0) {
                    if (idxFirstZero < 0) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }

            [ret appendBytes:&outbuf[idxFirstZero + 1] length:idxNextZero - idxFirstZero - 1];
        }
    }

    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

static NSData *encryptDataWithKeyRef(NSData *data, SecKeyRef keyRef, BOOL isSign) {
    const uint8_t *srcbuf = (const uint8_t *) [data bytes];
    size_t srclen = (size_t) data.length;

    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;

    NSMutableData *ret = [[NSMutableData alloc] init];
    for (int idx = 0; idx < srclen; idx += src_block_size) {
        size_t data_len = srclen - idx;
        if (data_len > src_block_size) {
            data_len = src_block_size;
        }

        size_t outlen = block_size;
        OSStatus status = noErr;
        if (isSign) {
            status = SecKeyRawSign(
                    keyRef,
                    kSecPaddingPKCS1,
                    srcbuf + idx,
                    data_len,
                    outbuf,
                    &outlen);
        } else {
            status = SecKeyEncrypt(keyRef,
                    kSecPaddingPKCS1,
                    srcbuf + idx,
                    data_len,
                    outbuf,
                    &outlen
            );
        }
        if (status != 0) {
            PBLog(@"SecKeyEncrypt fail. Error Code: %d", (int) status);
            ret = nil;
            break;
        } else {
            [ret appendBytes:outbuf length:outlen];
        }
    }

    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

@end