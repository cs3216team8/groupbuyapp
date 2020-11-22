import React from 'react';
import Button from '../components/Button';
import Card from '../components/Card';
import CustomerCard from '../components/CustomerCard';
import LabelText from '../components/LabelText';
import Layout from '../components/layout/Layout';
import SplitSection from '../components/SplitSection';
import StatsBox from '../components/StatsBox';
import customerData from '../data/customer-data';
import AddToCart from '../svg/addToCart.inline.svg';
import First from '../svg/first.inline.svg';
import Second from '../svg/second.inline.svg';
import Third from '../svg/third.inline.svg';
import Form from '../components/Form';
import { Helmet } from 'react-helmet';
import InstagramIcon from '../svg/InstagramIcon';
import playStore from '../svg/playStore.png';
import appStore from '../svg/appStore.svg';

export default () => (
  <Layout>
    <Helmet>
      <meta charSet="utf-8" />
      <title>PiggyBuy</title>
      <link rel="canonical" href="http://mysite.com/example" />
    </Helmet>
    <section className="pt-20 md:pt-30">
      <div className="container mx-auto px-8 lg:flex">
        <div className="text-center lg:text-left lg:w-1/2">
          <h1 className="mr-4 mt-4 text-4xl lg:text-5xl xl:text-6xl font-bold leading-none">
            Get better deals with PiggyBuy
          </h1>
          <p className="text-xl lg:text-2xl mt-6 font-light">
            Save on delivery costs and earn rewards together.
          </p>

          <p className="mt-8 md:mt-8 mb-12 flex justify-center lg:justify-start">
            <a
              className="mr-4"
              href="https://play.google.com/store/apps/details?id=com.team8.groupbuyapp"
              target="_blank"
            >
              <img
                className="z-0 transform ease-out hover:-translate-y-px"
                width="200"
                src={playStore}
              />
            </a>
            <a className="mr-4" href="https://apps.apple.com/us/app/piggybuy/id1538311769" target="_blank">
              <img
                className="z-0 transition ease-out duration-50 transform hover:-translate-y-px"
                width="156"
                src={appStore}
              />
            </a>
          </p>
          <p className="hidden lg:flex mt-12 lg:mt-14 flex justify-center lg:justify-start">
            <Form />
          </p>
          <p className="hidden lg:flex mt-4 mb-8 text-gray-600">
            Sign up with your email for updates about PiggyBuy!
          </p>
        </div>
        <div className="lg:w-1/2">
          <AddToCart />
        </div>
      </div>
    </section>
    <section id="features" className="py-20 lg:pb-40 lg:pt-40">
      <div className="container mx-auto text-center">
        <h2 className="text-3xl lg:text-5xl font-semibold">Why PiggyBuy?</h2>
        <div className="flex flex-col sm:flex-row sm:-mx-3 mt-12">
          <div className="flex-1 px-3">
            <Card className="transition ease-out duration-500 transform hover:scale-105 mb-8">
              <p className="font-semibold text-xl">Save delivery costs</p>
              <p className="mt-4">
                PiggyBuy helps you hit the minimum free shipping and piggyback on discount cards
              </p>
            </Card>
          </div>
          <div className="flex-1 px-3">
            <Card className="transition ease-out duration-500 transform hover:scale-105 mb-8">
              <p className="font-semibold text-xl">Get cashback & rewards</p>
              <p className="mt-4">
                PiggyBuy helps you earn rewards on your credit card without having to pay more
              </p>
            </Card>
          </div>
          <div className="flex-1 px-3">
            <Card className="transition duration-500 transform hover:scale-105 mb-8">
              <p className=" font-semibold text-xl">Meet your neighbours</p>
              <p className="mt-4">
                Using PiggyBuy is a neat excuse to meet your neighbour and have a nice chat
              </p>
            </Card>
          </div>
        </div>
      </div>
    </section>
    <SplitSection
      id="services"
      primarySlot={
        <div className="lg:pr-32 xl:pr-48 ">
          <h3 className="text-3xl font-semibold leading-tight">Connect with nearby shoppers</h3>
          <p className="mt-8 text-xl font-light leading-relaxed">
            Our application will connect you with neighbouring shoppers who want to purchase online.
          </p>
        </div>
      }
      secondarySlot={<First />}
    />
    <SplitSection
      reverseOrder
      primarySlot={
        <div className="lg:pl-32 xl:pl-48">
          <h3 className="text-3xl font-semibold leading-tight">Purchase online together</h3>
          <p className="mt-8 text-xl font-light leading-relaxed">
            Once you have connected with neighbouring shoppers, you can purchase online together.
          </p>
        </div>
      }
      secondarySlot={<Second />}
    />
    <SplitSection
      primarySlot={
        <div className="lg:pr-32 xl:pr-48">
          <h3 className="text-3xl font-semibold leading-tight">Get a better deal</h3>
          <p className="mt-8 text-xl font-light leading-relaxed">
            By making your purchase together, your delivery costs will be lowered.
          </p>
        </div>
      }
      secondarySlot={<Third />}
    />
    {/* <section id="stats" className="py-20 lg:pt-32">
      <div className="container mx-auto text-center">
        <LabelText className="text-gray-600">Our customers get results</LabelText>
        <div className="flex flex-col sm:flex-row mt-8 lg:px-24">
          <div className="w-full sm:w-1/3">
            <StatsBox primaryText="$10" secondaryText="Reduced delivery cost on average" />
          </div>
          <div className="w-full sm:w-1/3">
            <StatsBox primaryText="500" secondaryText="Group purchases each day" />
          </div>
          <div className="w-full sm:w-1/3">
            <StatsBox primaryText="+100%" secondaryText="Customer Satisfaction" />
          </div>
        </div>
      </div>
    </section>
    <section id="testimonials" className="py-20 lg:py-40">
      <div className="container mx-auto">
        <LabelText className="mb-8 text-gray-600 text-center">What customers are saying</LabelText>
        <div className="flex flex-col md:flex-row md:-mx-3">
          {customerData.map(customer => (
            <div key={customer.customerName} className="flex-1 px-3">
              <CustomerCard customer={customer} />
            </div>
          ))}
        </div>
      </div>
    </section> */}
    <section
      id="newsletter"
      className="container mx-auto my-20 py-24 bg-primary-lighter rounded-lg text-center"
    >
      <h3 className="text-5xl font-semibold">Ready to save on your purchases?</h3>
      <p className="mt-8 text-xl font-light">
        Sign up with your email for the latest updates on PiggyBuy and stand a chance to win
        GrabFood vouchers!
      </p>
      <div className="mt-8 flex justify-center">
        <svg
          class="animate-bounce w-6 h-6 text-pink-500"
          fill="none"
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path d="M19 14l-7 7m0 0l-7-7m7 7V3"></path>
        </svg>
      </div>
      <div className=" flex justify-center">
        {/* <Button size="xl" className="mx-6 mt-4">App Store</Button>
        <Button size="xl" className="mx-6 mt-4">Play Store</Button> */}
        <Form />
      </div>
    </section>
  </Layout>
);
