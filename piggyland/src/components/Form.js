import React, { useState } from 'react';
import addToMailchimp from 'gatsby-plugin-mailchimp'

const Form = () => {
  const [email, setEmail] = useState('');
  const handleSubmit = async (e) => {
    e.preventDefault();
    alert("Email received, we'll send you updates about PiggyBuy!");
    const result = await addToMailchimp(email);
    console.log(result);
    setEmail("");
  }
  return (
    <form className="w-full max-w-sm" onSubmit={handleSubmit}>
      <div className="flex items-center border-b  border-pink-500 py-2">
        <input
          class="bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-pink-500"
          id="inline-full-name"
          type="text"
          placeholder="Your email address..."
          onChange={e => setEmail(e.target.value)}
        />
        <button
          className="flex-shrink-0 bg-primary hover:bg-primary-darker primary hover:primary-darker text-m text-white ml-1 py-2 px-4 rounded"
          type="button"
          onClick={handleSubmit}
        >
          Sign Up
        </button>
      </div>
    </form>
  );
};

export default Form;
