# -----------------------------------------------------------------------
# SP24 CMPSC 360 Extra Credit Assignment 2
# RSA Implementation
# 
# Name: <YOUR NAME>
# ID: <YOUR PSU ID>
# 
# 
# You cannot use any external/built-in libraries to help compute gcd
# or modular inverse. You cannot use RSA, cryptography, or similar libs
# for this assignment. You must write your own implementation for generating
# large primes. You must wirte your own implementation for modular exponentiation and
# modular inverse.
# 
# You are allowed to use randint from the built-in random library
# -----------------------------------------------------------------------

from typing import Tuple
import random
import math

# Type defs
Key = Tuple[int, int]

def _is_prime(candidate):
    upper_bound = math.floor(math.sqrt(candidate))

    for i in range(2, upper_bound + 1):
        if upper_bound % i == 0: 
            return False 
        
    return True 

print(_is_prime(6))
def _extended_gcd(a, b):
    """
    Helper function to compute the Extended GCD of a and b.
    
    Returns:
        gcd, x, y such that gcd(a, b) = x * a + y * b
    """
    if b == 0:
        return a, 1, 0
    
    gcd, x1, y1 = _extended_gcd(b, a % b)
    x = y1
    y = x1 - (a // b) * y1

    return gcd, x, y

def _mod_inverse(a, m): 
    gcd, x, _ = _extended_gcd(a, m)

    if gcd != 1:
        # Modular inverse doesn't exist if gcd(a, m) != 1
        return None
    else:
        # Modular inverse is x mod m
        return x % m

def generate_prime(n: int) -> int:
    '''
    Description: Generate a random n-bit prime number
    Args: n (No. of bits)
    Returns: Random n-bit prime number
    '''

    lower_bound = 2**(n-1)
    upper_bound = 2**n - 1

    # Edge case for small n (e.g., n=1)
    if n == 1:
        return random.choice([2, 3, 5, 7])

    size = upper_bound - lower_bound + 1
    is_prime = [True] * size  # Assume all numbers in range are prime

    # Iterate over possible factors
    for i in range(2, int(math.sqrt(upper_bound)) + 1):
        # Find the smallest multiple of i within the range
        start = max(i**2, lower_bound + (i - lower_bound % i) % i)

        # Mark multiples of i as non-prime
        for j in range(start, upper_bound + 1, i):
            is_prime[j - lower_bound] = False

    primes = [] 
    for i in range(size): 
        if is_prime[i]: 
            primes.append(lower_bound + i) 
    
    return random.choice(primes) 

def generate_keypair(p: int, q: int) -> Tuple[Key, Key]:
    '''
    Description: Generates the public and private key pair
    if p and q are distinct primes. Otherwise, raise a value error
    
    Args: p, q (input integers)

    Returns: Keypair in the form of (Pub Key, Private Key)
    PubKey = (n,e) and Private Key = (n,d)
    '''

    if p == q: 
        raise ValueError
    
    if not (_is_prime(p) or _is_prime(q)): 
        raise ValueError 
    
    n = p * q 
    phi = (p - 1) * (q - 1)
    
    e = 65537  # Choose e such that gcd(e, phi) == 1
    d = _mod_inverse(e, phi)  # Must define this later 
    
    public_key = (n, e)
    private_key = (n, d)
    
    return public_key, private_key     

def rsa_encrypt(m: str, pub_key: Key, blocksize: int) -> int:
    '''
    Description: Encrypts the message with the given public
    key using the RSA algorithm.

    Args: m (input string)

    Returns: c (encrypted cipher)
    NOTE: You CANNOT use the built-in pow function (or any similar function)
    here.
    '''
    raise NotImplementedError


def rsa_decrypt(c: str, priv_key: Key, blocksize: int) -> int:
    '''
    Description: Decrypts the ciphertext using the private key
    according to RSA algorithm

    Args: c (encrypted cipher string)

    Returns: m (decrypted message, a string)
    NOTE: You CANNOT use the built-in pow function (or any similar function)
    here.
    '''
    raise NotImplementedError

# 'abc'

def chunk_to_num( chunk ):
    '''
    Description: Convert chunk (substring) to a unique number mod n^k
    n is the common modulus, k is length of chunk.

    Args: chunk (a substring of some messages)

    Returns: r (some integer)
    NOTE: You CANNOT use any built-in function to implement base conversion. 
    ''' 

    offset = 32 
    mod_base = 128 - offset 
    result = 0

    for i in range(len(chunk) - 1, -1, -1): 
        ascii_char = ord(chunk[i])
        result += (ascii_char - offset) * (mod_base**i)

    return result 

def num_to_chunk(num, chunksize):
    '''
    Description: Convert a number back to a chunk using a given 
    chunk size.

    Args: 
        num (integer): The number to be converted back to a chunk.
        chunksize (integer): The size of the resulting chunk.

    Returns: 
        chunk (str): The resulting substring.
    '''
    offset = 32
    mod_base = 128 - offset
    chunk = ""  # Initialize the chunk with empty characters.

    for i in range(chunksize):
        # Calculate the current character code and update `num`.
        char_code = (num // (mod_base ** i)) % mod_base + offset
        chunk += chr(char_code)
    
    return ''.join(chunk)