#include <iostream>
#include <string>
#include <vector>

using namespace std;

// Function to convert a character to its corresponding numeric value (A=0, B=1, ..., Z=25)
int charToNum(char c) {
    return c - 'A';
}

// Function to convert a numeric value to its corresponding character (0=A, 1=B, ..., 25=Z)
char numToChar(int n) {
    return 'A' + n;
}

// Function to calculate the modular inverse of a number a mod m
int modInverse(int a, int m) {
    a = a % m;
    for (int x = 1; x < m; x++) {
        if ((a * x) % m == 1) {
            return x;
        }
    }
    return -1;  // Modular inverse doesn't exist
}

// Function to perform matrix multiplication
vector<int> matrixMultiply(vector<vector<int>>& keyMatrix, vector<int>& messageVector) {
    int n = keyMatrix.size();
    vector<int> result(n, 0);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            result[i] += keyMatrix[i][j] * messageVector[j];
        }
        result[i] %= 26;
    }

    return result;
}

// Function to perform Hill cipher encryption
string encrypt(string message, vector<vector<int>>& keyMatrix) {
    string encryptedMessage = "";
    int n = keyMatrix.size();

    // Pad the message with 'X' if its length is not a multiple of n
    while (message.length() % n != 0) {
        message += 'X';
    }

    for (int i = 0; i < message.length(); i += n) {
        vector<int> messageVector(n, 0);
        vector<int> encryptedVector;

        // Convert the current block of characters to numeric values
        for (int j = 0; j < n; j++) {
            messageVector[j] = charToNum(message[i + j]);
        }

        // Perform matrix multiplication
        encryptedVector = matrixMultiply(keyMatrix, messageVector);

        // Convert the encrypted vector back to characters
        for (int j = 0; j < n; j++) {
            encryptedMessage += numToChar(encryptedVector[j]);
        }
    }

    return encryptedMessage;
}

// Function to perform Hill cipher decryption
string decrypt(string encryptedMessage, vector<vector<int>>& keyMatrix) {
    string decryptedMessage = "";
    int n = keyMatrix.size();
    int determinant = 0;

    // Calculate the determinant of the key matrix
    if (n == 2) {
        determinant = keyMatrix[0][0] * keyMatrix[1][1] - keyMatrix[0][1] * keyMatrix[1][0];
    } else if (n == 3) {
        determinant = keyMatrix[0][0] * (keyMatrix[1][1] * keyMatrix[2][2] - keyMatrix[1][2] * keyMatrix[2][1])
                    - keyMatrix[0][1] * (keyMatrix[1][0] * keyMatrix[2][2] - keyMatrix[1][2] * keyMatrix[2][0])
                    + keyMatrix[0][2] * (keyMatrix[1][0] * keyMatrix[2][1] - keyMatrix[1][1] * keyMatrix[2][0]);
    }

    // Calculate the modular inverse of the determinant
    int detInverse = modInverse(determinant, 26);

    // Calculate the adjugate of the key matrix
    vector<vector<int>> adjugateMatrix(n, vector<int>(n, 0));
    if (n == 2) {
        adjugateMatrix[0][0] = keyMatrix[1][1];
        adjugateMatrix[0][1] = -keyMatrix[0][1];
        adjugateMatrix[1][0] = -keyMatrix[1][0];
        adjugateMatrix[1][1] = keyMatrix[0][0];
    } else if (n == 3) {
        adjugateMatrix[0][0] = keyMatrix[1][1] * keyMatrix[2][2] - keyMatrix[1][2] * keyMatrix[2][1];
        adjugateMatrix[0][1] = keyMatrix[0][2] * keyMatrix[2][1] - keyMatrix[0][1] * keyMatrix[2][2];
        adjugateMatrix[0][2] = keyMatrix[0][1] * keyMatrix[1][2] - keyMatrix[0][2] * keyMatrix[1][1];
        adjugateMatrix[1][0] = keyMatrix[1][2] * keyMatrix[2][0] - keyMatrix[1][0] * keyMatrix[2][2];
        adjugateMatrix[1][1] = keyMatrix[0][0] * keyMatrix[2][2] - keyMatrix[0][2] * keyMatrix[2][0];
        adjugateMatrix[1][2] = keyMatrix[0][2] * keyMatrix[1][0] - keyMatrix[0][0] * keyMatrix[1][2];
        adjugateMatrix[2][0] = keyMatrix[1][0] * keyMatrix[2][1] - keyMatrix[1][1] * keyMatrix[2][0];
        adjugateMatrix[2][1] = keyMatrix[0][1] * keyMatrix[2][0] - keyMatrix[0][0] * keyMatrix[2][1];
        adjugateMatrix[2][2] = keyMatrix[0][0] * keyMatrix[1][1] - keyMatrix[0][1] * keyMatrix[1][0];
    }

    // Calculate the inverse key matrix
    vector<vector<int>> inverseMatrix(n, vector<int>(n, 0));
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            inverseMatrix[i][j] = (adjugateMatrix[i][j] * detInverse) % 26;
            if (inverseMatrix[i][j] < 0) {
                inverseMatrix[i][j] += 26;
            }
        }
    }

    // Decrypt the message
    for (int i = 0; i < encryptedMessage.length(); i += n) {
        vector<int> encryptedVector(n, 0);
        vector<int> decryptedVector;

        // Convert the current block of characters to numeric values
        for (int j = 0; j < n; j++) {
            encryptedVector[j] = charToNum(encryptedMessage[i + j]);
        }

        // Perform matrix multiplication
        decryptedVector = matrixMultiply(inverseMatrix, encryptedVector);

        // Convert the decrypted vector back to characters
        for (int j = 0; j < n; j++) {
            decryptedMessage += numToChar(decryptedVector[j]);
        }
    }

    return decryptedMessage;
}

int main() {
    string message;
    vector<vector<int>> keyMatrix;
    int n;

    cout << "Enter the message to encrypt: ";
    getline(cin, message);

    cout << "Enter the dimension of the key matrix: ";
    cin >> n;

    cout << "Enter the key matrix (row by row):\n";
    for (int i = 0; i < n; i++) {
        vector<int> row;
        for (int j = 0; j < n; j++) {
            int element;
            cin >> element;
            row.push_back(element);
        }
        keyMatrix.push_back(row);
    }

    // Encrypt the message
    string encryptedMessage = encrypt(message, keyMatrix);
    cout << "Encrypted message: " << encryptedMessage << endl;

    // Decrypt the message
    string decryptedMessage = decrypt(encryptedMessage, keyMatrix);
    cout << "Decrypted message: " << decryptedMessage << endl;

    return 0;
}
