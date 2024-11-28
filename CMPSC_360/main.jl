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
# large primes. You must write your own implementation for modular exponentiation
# and modular inverse.
#
# You are allowed to use rand from the built-in Random library
# -----------------------------------------------------------------------
using Random

# Function to generate an n-bit prime number
function generate_prime(n::Int)
    """
    Description: Generate an n-bit prime number
    Args: n (No. of bits)
    Returns: prime number
    NOTE: This needs to be sufficiently fast or you may not get
    any credit even if you correctly return a prime number.
    """

    is_prime = trues(n)  # `trues(n)` creates an array of `true` values of size `n`
    is_prime[1] = false  # 1 is not a prime number

    # Step 2: Sieve process
    for i in 2:floor(Int, sqrt(n))  # Only check up to √n
        
        if is_prime[i]
            
            # Mark multiples of i as non-prime
            for j in i^2:i:n
                is_prime[j] = false
                
            end
        end
    end

    # Step 3: Collect and return the primes
    return findall(is_prime)  # `findall` returns the indices of `true` values
end

# # Function to generate the public and private key pair
function generate_keypair(p::Int, q::Int)::Tuple{Key, Key}
    """
    Description: Generates the public and private key pair
    if p and q are distinct primes. Otherwise, raise a value error
    Args: p, q (input integers)
    Returns: Keypair in the form of (Pub Key, Private Key)
    PubKey = (n,e) and Private Key = (n,d)
    """

    if p == q 
        throw(ValueError("Values must be different"))
    end 
    
    n = p * q 
    phi = (p - 1) * (q - 1)
    
    e = 65537  # Choose e such that gcd(e, phi) == 1
    d = mod_inverse(e, phi)  # Must define this later 
    
    public_key = (n, e)
    private_key = (n, d)
    
    return public_key, private_key 

    
end

function rsa_encrypt(m::String, pub_key::Key, blocksize::Int)::Int
    """
    Description: Encrypts the message with the given public
    key using the RSA algorithm.
    Args: m (input string)
    Returns: c (encrypted cipher)
    NOTE: You CANNOT use the built-in pow function (or any similar function)
    here.
    """



end

function rsa_decrypt(c::String, priv_key::Key, blocksize::Int)::Int
    """
    Description: Decrypts the ciphertext using the private key
    according to RSA algorithm
    Args: c (encrypted cipher string)
    Returns: m (decrypted message, a string)
    NOTE: You CANNOT use the built-in pow function (or any similar function)
    here.
    """
    throw(NotImplementedError())
end

function chunk_to_num(chunk::String, n::Int)::Int
    """
    Converts a chunk (substring) into a unique integer mod n^k.
    
    Args:
        chunk: A string representing the substring.
        n: The modulus base for the conversion.
        
    Returns:
        An integer representation of the chunk.
    """
    k = length(chunk)
    result = 0
    for (i, char) in enumerate(reverse(chunk))
        # Convert character to its ASCII value and apply positional weighting
        result += (Int(char) % n) * (n ^ (i - 1))
    end
    return result
end

function num_to_chunk(num::Int, chunksize::Int, n::Int)::String
    """
    Converts a number back into a chunk (substring) using the given chunk size.
    
    Args:
        num: The integer to convert.
        chunksize: The length of the chunk (substring).
        n: The modulus base for conversion.
        
    Returns:
        A string representing the chunk.
    """

    chunk = ""
    for _ in 1:chunksize
        # Extract the last "digit" in base-n
        remainder = num % n
        # Convert back to a character
        chunk = Char(remainder) * chunk
        # Reduce the number
        num ÷= n
    end
    return chunk
end
