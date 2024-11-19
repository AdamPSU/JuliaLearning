# Type Definitions
const Key = Tuple{Int, Int}

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

println(generate_prime(50))

# # Function to generate the public and private key pair
# function generate_keypair(p::Int, q::Int)::Tuple{Key, Key}
#     """
#     Description: Generates the public and private key pair
#     if p and q are distinct primes. Otherwise, raise a value error
#     Args: p, q (input integers)
#     Returns: Keypair in the form of (Pub Key, Private Key)
#     PubKey = (n,e) and Private Key = (n,d)
#     """
#     throw(NotImplementedError("generate_keypair not implemented"))
# end

# # Function to encrypt a message using RSA
# function rsa_encrypt(m::String, pub_key::Key, blocksize::Int)::Int
#     """
#     Description: Encrypts the message with the given public
#     key using the RSA algorithm.
#     Args: m (input string)
#     Returns: c (encrypted cipher)
#     NOTE: You CANNOT use the built-in pow function (or any similar function)
#     here.
#     """
#     throw(NotImplementedError("rsa_encrypt not implemented"))
# end

# # Function to decrypt a ciphertext using RSA
# function rsa_decrypt(c::String, priv_key::Key, blocksize::Int)::Int
#     """
#     Description: Decrypts the ciphertext using the private key
#     according to RSA algorithm
#     Args: c (encrypted cipher string)
#     Returns: m (decrypted message, a string)
#     NOTE: You CANNOT use the built-in pow function (or any similar function)
#     here.
#     """
#     throw(NotImplementedError("rsa_decrypt not implemented"))
# end
